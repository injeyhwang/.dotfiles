-- [[ Tooling ]]

return {
  -- Configure Mason and install requested tools
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = { "shfmt", "stylua" },
    },
    config = function(_, opts)
      local ensure_installed = opts.ensure_installed or {}
      opts = vim.deepcopy(opts)
      opts.ensure_installed = nil
      require("mason").setup(opts)

      local registry = require("mason-registry")

      -- Refresh the registry before installing missing tools
      registry.refresh(function()
        for _, name in ipairs(ensure_installed) do
          local ok, package = pcall(registry.get_package, name)
          if not ok then
            vim.notify('Mason package "' .. name .. '" is unavailable', vim.log.levels.WARN)
          elseif
            not package:is_installed()
            and not package:is_installing()
            and not package:is_uninstalling()
          then
            package:install()
          end
        end
      end)
    end,
  },

  -- Leave Mason LSP setup to the server configuration
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    dependencies = { "mason-org/mason.nvim" },
    config = function() end,
  },
}
