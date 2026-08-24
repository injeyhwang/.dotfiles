-- [[ Git Signs ]]

-- Show Git changes in the sign column
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
  end,
}
