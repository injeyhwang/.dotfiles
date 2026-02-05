return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- 'storm', 'moon', 'night', 'day'
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.section_separators = ""
      opts.options.component_separators = { left = "|", right = "|" }
    end,
  },
  -- Configure Trouble (diagnostics list)
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
}
