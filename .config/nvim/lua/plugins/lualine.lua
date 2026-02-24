return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local colors = require("tokyonight.colors").setup({ style = "night" })

    -- themes for lualine_a section
    local function mode_a(bg)
      return { bg = bg, fg = colors.black, gui = "bold" }
    end

    -- themes for lualine_c section
    local function mode_c()
      return { fg = colors.fg, bg = colors.bg }
    end

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      screen_width = function(min_w)
        return function()
          return vim.o.columns > min_w
        end
      end,
      in_git_repo = function()
        return vim.b.gitsigns_head ~= nil
      end,
    }

    vim.o.laststatus = vim.g.lualine_laststatus
    return {
      options = {
        globalstatus = vim.o.laststatus == 3,
        component_separators = "",
        section_separators = "",
        theme = {
          normal = {
            a = mode_a(colors.blue),
            c = mode_c(),
          },
          insert = {
            a = mode_a(colors.green),
            c = mode_c(),
          },
          command = {
            a = mode_a(colors.yellow),
            c = mode_c(),
          },
          visual = {
            a = mode_a(colors.magenta),
            c = mode_c(),
          },
          replace = {
            a = mode_a(colors.red),
            c = mode_c(),
          },
          terminal = {
            a = mode_a(colors.orange),
            c = mode_c(),
          },
          inactive = {
            a = { bg = colors.bg, fg = colors.fg_dark },
            c = { fg = colors.fg_dark, bg = colors.bg },
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {
          {
            "branch",
            icon = "",
            color = { fg = colors.fg, bg = colors.bg, gui = "bold" },
            cond = conditions.in_git_repo,
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.orange },
              removed = { fg = colors.red },
            },
            cond = conditions.screen_width(80),
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          },
          {
            "filename",
            path = 0,
            cond = conditions.buffer_not_empty,
          },
          {
            function()
              return "%="
            end,
          },
        },
        lualine_x = {
          {
            "location",
            cond = conditions.buffer_not_empty,
          },
          "progress",
          "encoding",
          "filetype",
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
