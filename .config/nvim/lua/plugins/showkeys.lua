-- [[ Key Display ]]

-- Display recent keystrokes on demand
return {
  "nvzone/showkeys",
  cmd = "ShowkeysToggle",
  keys = {
    {
      "<leader>uK",
      "<cmd>ShowkeysToggle<cr>",
      desc = "Toggle Showkeys",
    },
  },
  opts = {
    timeout = 3,
    maxkeys = 5,
    position = "bottom-left",
  },
  config = function(_, opts)
    require("showkeys").setup(opts)
  end,
}
