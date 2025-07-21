-- =====================================================
-- Code Formatting Configuration
-- =====================================================
-- This file configures conform.nvim for automatic code formatting.
-- Handles formatters like prettier (web), black (Python), and stylua (Lua)
-- with custom indentation settings per language.

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Python: 4 spaces
      python = { 'black', 'isort' },
      -- Web: 2 spaces
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      json = { 'prettier' },
      markdown = { 'prettier' },
    },
    formatters = {
      prettier = {
        prepend_args = { '--tab-width', '2', '--use-tabs', 'false' },
      },
      black = {
        prepend_args = { '--line-length', '88', '--indent', '4' },
      },
    },
  },
}