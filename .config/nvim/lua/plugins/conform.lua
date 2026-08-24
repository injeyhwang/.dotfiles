-- [[ Formatting ]]

-- Format buffers with external tools and an LSP fallback
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  dependencies = { "mason-org/mason.nvim" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "n",
      desc = "Format Buffer",
    },
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "x",
      desc = "Format Selection",
    },
  },

  -- Enable autoformatting by default and route formatexpr through Conform
  init = function()
    if vim.g.autoformat == nil then
      vim.g.autoformat = true
    end

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
      timeout_ms = 3000,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      sh = { "shfmt" },
      swift = { "swiftformat" },
    },

    -- Format on save unless disabled globally or for the current buffer
    format_on_save = function(buffer)
      if vim.g.autoformat == false or vim.b[buffer].autoformat == false then
        return
      end

      return {
        lsp_format = "fallback",
        timeout_ms = 3000,
      }
    end,
  },
}
