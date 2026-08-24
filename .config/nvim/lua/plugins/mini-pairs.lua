-- [[ Pairs ]]

-- Insert matching pairs in insert and command-line modes
return {
  "nvim-mini/mini.pairs",
  event = "VeryLazy",
  opts = {
    modes = {
      insert = true,
      command = true,
      terminal = false,
    },
  },
}
