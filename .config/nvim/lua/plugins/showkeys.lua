return {
  "nvzone/showkeys",
  event = "VeryLazy",
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
    position = "top-right",
  },
  config = function(_, opts)
    require("showkeys").setup(opts)
  end
}
