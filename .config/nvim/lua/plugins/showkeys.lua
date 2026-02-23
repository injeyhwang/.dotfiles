return {
  "nvzone/showkeys",
  event = "VeryLazy",
  cmd = "ShowkeysToggle",
  opts = {
    timeout = 3,
    maxkeys = 5,
  },
  config = function(_, opts)
    require("showkeys").setup(opts)
    require("showkeys").toggle()
  end
}
