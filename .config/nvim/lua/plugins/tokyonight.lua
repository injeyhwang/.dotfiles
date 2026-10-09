-- [[ Colorscheme ]]

-- Apply Tokyo Night during startup
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = { style = "night", light_style = "day" },
  config = function(_, opts)
    require("tokyonight").setup(opts)

    local function apply_theme()
      vim.cmd.colorscheme(vim.o.background == "light" and "tokyonight-day" or "tokyonight-night")
    end

    -- Neovim updates 'background' when terminal reports an appearance change.
    vim.api.nvim_create_autocmd("OptionSet", {
      group = vim.api.nvim_create_augroup("TokyoNightAppearance", { clear = true }),
      pattern = "background",
      desc = "Match tokyonight theme to the terminal appearance",
      nested = true,
      callback = apply_theme,
    })

    apply_theme()
  end,
}
