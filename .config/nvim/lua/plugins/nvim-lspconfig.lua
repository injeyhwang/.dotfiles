-- [[ Language Servers ]]

local diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = " ",
}

-- Jump through diagnostics and show details at the destination
local function diagnostic_jump(count, severity)
  return function()
    vim.diagnostic.jump({
      count = count * vim.v.count1,
      severity = severity,
      on_jump = function(_, buffer)
        vim.diagnostic.open_float({
          bufnr = buffer,
          scope = "cursor",
          focus = false,
        })
      end,
    })
  end
end

-- Add buffer-local LSP keymaps only when the client supports them
local function setup_keymaps(client, buffer)
  local methods = vim.lsp.protocol.Methods
  local function map(mode, lhs, rhs, method, desc, opts)
    if method and not client:supports_method(method, buffer) then
      return
    end

    vim.keymap.set(
      mode,
      lhs,
      rhs,
      vim.tbl_extend("force", {
        buf = buffer,
        desc = desc,
        silent = true,
      }, opts or {})
    )
  end

  map("n", "gd", vim.lsp.buf.definition, methods.textDocument_definition, "Goto Definition")
  map(
    "n",
    "gr",
    vim.lsp.buf.references,
    methods.textDocument_references,
    "References",
    { nowait = true }
  )
  map(
    "n",
    "gI",
    vim.lsp.buf.implementation,
    methods.textDocument_implementation,
    "Goto Implementation"
  )
  map(
    "n",
    "gy",
    vim.lsp.buf.type_definition,
    methods.textDocument_typeDefinition,
    "Goto Type Definition"
  )
  map("n", "gD", vim.lsp.buf.declaration, methods.textDocument_declaration, "Goto Declaration")

  map("n", "K", vim.lsp.buf.hover, methods.textDocument_hover, "Hover")
  map("n", "gK", vim.lsp.buf.signature_help, methods.textDocument_signatureHelp, "Signature Help")
  map(
    "i",
    "<C-k>",
    vim.lsp.buf.signature_help,
    methods.textDocument_signatureHelp,
    "Signature Help"
  )

  map(
    { "n", "x" },
    "<leader>ca",
    vim.lsp.buf.code_action,
    methods.textDocument_codeAction,
    "Code Action"
  )
  map("n", "<leader>cr", vim.lsp.buf.rename, methods.textDocument_rename, "Rename")
end

-- Configure diagnostics and language servers for supported filetypes
return {
  "neovim/nvim-lspconfig",
  ft = { "lua", "python", "swift" },
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    { "]d", diagnostic_jump(1), desc = "Next Diagnostic" },
    { "[d", diagnostic_jump(-1), desc = "Previous Diagnostic" },
    { "]e", diagnostic_jump(1, vim.diagnostic.severity.ERROR), desc = "Next Error" },
    { "[e", diagnostic_jump(-1, vim.diagnostic.severity.ERROR), desc = "Previous Error" },
    { "]w", diagnostic_jump(1, vim.diagnostic.severity.WARN), desc = "Next Warning" },
    { "[w", diagnostic_jump(-1, vim.diagnostic.severity.WARN), desc = "Previous Warning" },
  },
  opts = {
    diagnostics = {
      severity_sort = true,
      signs = { text = diagnostic_icons },
      underline = true,
      update_in_insert = false,
      virtual_text = {
        prefix = "●",
        source = "if_many",
        spacing = 4,
      },
    },
    inlay_hints = {
      enabled = true,
      exclude = {},
    },
    servers = {
      -- Apply shared capabilities to every configured server
      ["*"] = {
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            hint = {
              enable = true,
              arrayIndex = "Disable",
              paramName = "Disable",
              paramType = true,
              semicolon = "Disable",
              setType = false,
            },
          },
        },
      },
      pyright = {},
      ruff = {
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
      },
      sourcekit = {
        mason = false,
        filetypes = { "swift" },
      },
    },

    -- Allow extensions to handle server setup before the default path
    setup = {},
  },
  config = function(_, opts)
    -- Apply shared server defaults and Blink completion capabilities
    local defaults = vim.deepcopy(opts.servers["*"] or {})
    defaults.capabilities = require("blink.cmp").get_lsp_capabilities(defaults.capabilities)
    vim.lsp.config("*", defaults)

    -- Enable inlay hints for supported, non-excluded buffers
    local hints = opts.inlay_hints
    if hints.enabled then
      Snacks.util.lsp.on(
        { method = vim.lsp.protocol.Methods.textDocument_inlayHint },
        function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end
      )
    end

    vim.diagnostic.config(opts.diagnostics)

    -- Attach supported keymaps whenever an LSP client joins a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("config_lsp_attach", { clear = true }),
      callback = function(event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

        -- Disable Ruff's redundant hover provider
        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end

        setup_keymaps(client, event.buf)
      end,
    })

    -- Configure enabled servers and collect those managed by Mason
    local ensure_installed = {}
    local automatic_enable = {}

    for name, server in pairs(opts.servers) do
      if name ~= "*" and server ~= false then
        server = server == true and {} or vim.deepcopy(server)
        local enabled = server.enabled ~= false
        local use_mason = server.mason ~= false
        server.enabled = nil
        server.mason = nil

        if enabled then
          local setup = opts.setup[name] or opts.setup["*"]
          local handled = setup and setup(name, server)
          if not handled then
            vim.lsp.config(name, server)
          end

          if use_mason then
            table.insert(ensure_installed, name)
            if not handled then
              table.insert(automatic_enable, name)
            end
          elseif not handled then
            vim.lsp.enable(name)
          end
        end
      end
    end

    table.sort(ensure_installed)
    table.sort(automatic_enable)

    -- Install and automatically enable Mason-managed servers
    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed,
      automatic_enable = automatic_enable,
    })
  end,
}
