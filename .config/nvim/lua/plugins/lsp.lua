return {
  -- Add specific servers to lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {},
    },
  },
  -- Tooling
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
