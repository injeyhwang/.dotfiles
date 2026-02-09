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
      opts.sections.lualine_z = {}
      opts.options.component_separators = { left = "|", right = "|" }
      opts.options.section_separators = ""
    end,
  },
  -- Configure Trouble (diagnostics list)
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
}
