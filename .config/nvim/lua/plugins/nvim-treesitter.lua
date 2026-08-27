-- [[ Tree-sitter ]]

local foldexpr = "v:lua.vim.treesitter.foldexpr()"
local indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Resolve each buffer's filetype to its Tree-sitter language
local function get_lang(buffer)
  local filetype = vim.bo[buffer].filetype
  return vim.treesitter.language.get_lang(filetype) or filetype
end

local function get_parser(buffer, lang)
  local ok, parser = pcall(vim.treesitter.get_parser, buffer, lang)
  return ok and parser or nil
end

local function get_query(lang, name)
  local ok, query = pcall(vim.treesitter.query.get, lang, name)
  return ok and query or nil
end

local function has_query(lang, name)
  return get_query(lang, name) ~= nil
end

-- Enable a feature only when its language is allowed and has the required query
local function feature_enabled(feature, lang, query)
  feature = feature or {}
  return feature.enable ~= false
    and not (type(feature.disable) == "table" and vim.tbl_contains(feature.disable, lang))
    and has_query(lang, query)
end

return {
  -- Configure parsers, highlighting, indentation, and folds
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash",
        "diff",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "swift",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = true },
    },
    config = function(_, opts)
      -- Initialize Tree-sitter with folds open by default
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      vim.opt.foldlevel = 99

      -- Attach highlighting and indentation only when the parser supports them
      local function attach(buffer)
        if not vim.api.nvim_buf_is_valid(buffer) or not vim.api.nvim_buf_is_loaded(buffer) then
          return
        end

        local lang = get_lang(buffer)
        local parser = get_parser(buffer, lang)
        local highlighted_lang = vim.b[buffer].config_treesitter_highlight

        -- Clear features whose parser is no longer available
        if not parser then
          if highlighted_lang then
            vim.treesitter.stop(buffer)
          end
          vim.b[buffer].config_treesitter_highlight = nil
          if vim.bo[buffer].indentexpr == indentexpr then
            vim.bo[buffer].indentexpr = ""
          end
          return
        end

        if feature_enabled(opts.highlight, lang, "highlights") then
          local restart = highlighted_lang and highlighted_lang ~= lang
          if restart then
            vim.treesitter.stop(buffer)
          end
          if not highlighted_lang or restart then
            local started = pcall(vim.treesitter.start, buffer, lang)
            if started then
              vim.b[buffer].config_treesitter_highlight = lang
            end
          end
        elseif highlighted_lang then
          vim.treesitter.stop(buffer)
          vim.b[buffer].config_treesitter_highlight = nil
        end

        if feature_enabled(opts.indent, lang, "indents") then
          vim.bo[buffer].indentexpr = indentexpr
        elseif vim.bo[buffer].indentexpr == indentexpr then
          vim.bo[buffer].indentexpr = ""
        end
      end

      -- Configure Tree-sitter folds per window when supported
      local function configure_folds(buffer, window)
        if not vim.api.nvim_win_is_valid(window) then
          return
        end

        if vim.api.nvim_win_get_buf(window) ~= buffer then
          return
        end

        local lang = get_lang(buffer)
        local folds_ok = get_parser(buffer, lang) ~= nil
          and feature_enabled(opts.folds, lang, "folds")
        if folds_ok then
          vim.wo[window].foldexpr = foldexpr
          vim.wo[window].foldmethod = "expr"
        elseif vim.wo[window].foldexpr == foldexpr then
          vim.wo[window].foldexpr = "0"
          vim.wo[window].foldmethod = "manual"
        end
      end

      -- Reapply features to buffers and windows that are already open
      local function attach_open_buffers()
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
          attach(buffer)
        end
        for _, window in ipairs(vim.api.nvim_list_wins()) do
          configure_folds(vim.api.nvim_win_get_buf(window), window)
        end
      end

      -- Refresh highlighting and indentation when a filetype is assigned
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
        callback = function(event)
          attach(event.buf)
        end,
      })

      -- Refresh folds when a supported buffer enters a window
      vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        group = vim.api.nvim_create_augroup("config_treesitter_folds", { clear = true }),
        callback = function(event)
          configure_folds(event.buf, vim.api.nvim_get_current_win())
        end,
      })

      attach_open_buffers()

      -- Install missing parsers and reattach features when installation finishes
      local installed = treesitter.get_installed("parsers")
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, opts.ensure_installed)

      if #missing > 0 then
        treesitter.install(missing, { summary = true }):await(function(err, success)
          vim.schedule(function()
            if err or not success then
              vim.notify(
                "Tree-sitter parser installation failed: "
                  .. tostring(err or "one or more parsers failed"),
                vim.log.levels.ERROR
              )
            else
              attach_open_buffers()
              vim.api.nvim_exec_autocmds("User", { pattern = "ConfigTreesitterInstalled" })
            end
          end)
        end)
      end
    end,
  },

  -- Add query-aware motions for functions, classes, and parameters
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      move = {
        set_jumps = true,
      },
      keys = {
        ["]f"] = {
          method = "goto_next_start",
          query = "@function.outer",
          desc = "Next Function Start",
        },
        ["]c"] = { method = "goto_next_start", query = "@class.outer", desc = "Next Class Start" },
        ["]a"] = {
          method = "goto_next_start",
          query = "@parameter.inner",
          desc = "Next Parameter Start",
        },

        ["]F"] = { method = "goto_next_end", query = "@function.outer", desc = "Next Function End" },
        ["]C"] = { method = "goto_next_end", query = "@class.outer", desc = "Next Class End" },
        ["]A"] = {
          method = "goto_next_end",
          query = "@parameter.inner",
          desc = "Next Parameter End",
        },

        ["[f"] = {
          method = "goto_previous_start",
          query = "@function.outer",
          desc = "Previous Function Start",
        },
        ["[c"] = {
          method = "goto_previous_start",
          query = "@class.outer",
          desc = "Previous Class Start",
        },
        ["[a"] = {
          method = "goto_previous_start",
          query = "@parameter.inner",
          desc = "Previous Parameter Start",
        },

        ["[F"] = {
          method = "goto_previous_end",
          query = "@function.outer",
          desc = "Previous Function End",
        },
        ["[C"] = {
          method = "goto_previous_end",
          query = "@class.outer",
          desc = "Previous Class End",
        },
        ["[A"] = {
          method = "goto_previous_end",
          query = "@parameter.inner",
          desc = "Previous Parameter End",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup({ move = opts.move })

      -- Remove mappings left by an earlier textobject attachment
      local function detach(buffer)
        for _, lhs in ipairs(vim.b[buffer].config_treesitter_textobjects or {}) do
          pcall(vim.keymap.del, { "n", "x", "o" }, lhs, { buf = buffer })
        end
        vim.b[buffer].config_treesitter_textobjects = nil
      end

      -- Attach motions only when the buffer has textobject queries
      local function attach(buffer)
        if not vim.api.nvim_buf_is_valid(buffer) or not vim.api.nvim_buf_is_loaded(buffer) then
          return
        end

        detach(buffer)
        local lang = get_lang(buffer)
        local query = get_query(lang, "textobjects")
        if not get_parser(buffer, lang) or not query then
          return
        end

        local attached = {}
        for lhs, key in pairs(opts.keys) do
          if vim.list_contains(query.captures, key.query:sub(2)) then
            vim.keymap.set({ "n", "x", "o" }, lhs, function()
              -- Defer class motions to their native keys in diff mode
              if vim.wo.diff and key.query == "@class.outer" then
                vim.cmd.normal({ vim.v.count1 .. lhs, bang = true })
                return
              end
              require("nvim-treesitter-textobjects.move")[key.method](key.query, "textobjects")
            end, { buf = buffer, desc = key.desc, silent = true })
            table.insert(attached, lhs)
          end
        end
        vim.b[buffer].config_treesitter_textobjects = attached
      end

      local function attach_open_buffers()
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
          attach(buffer)
        end
      end

      local group = vim.api.nvim_create_augroup("config_treesitter_textobjects", { clear = true })

      -- Refresh textobject motions when a filetype is assigned
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(event)
          attach(event.buf)
        end,
      })

      -- Reattach motions after missing parsers finish installing
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "ConfigTreesitterInstalled",
        callback = attach_open_buffers,
      })

      -- Attach motions to buffers that were already open
      attach_open_buffers()
    end,
  },
}
