return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.section_separators = ""
      opts.options.component_separators = { left = "|", right = "|" }
    end,
  },
}
