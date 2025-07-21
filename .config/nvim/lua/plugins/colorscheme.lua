-- =====================================================
-- Colorscheme Configuration
-- =====================================================
-- This file configures the Catppuccin color scheme to match
-- your shell environment. Catppuccin provides a warm, pastel
-- theme that's consistent across your terminal and nvim.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    -- Empty setup uses defaults
    require("catppuccin").setup()
    vim.cmd.colorscheme("catppuccin")
  end,
}

-- Modeline: code format config for this file
-- vim: ts=2 sts=2 sw=2 et
