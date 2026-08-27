-- [[ Enhanced Motion ]]

-- Navigate with labeled jumps and Tree-sitter-aware selections
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "s",
      function()
        require("flash").jump()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash",
    },
    {
      "S",
      function()
        require("flash").treesitter()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash Treesitter",
    },
    {
      "r",
      function()
        require("flash").remote()
      end,
      mode = "o",
      desc = "Remote Flash",
    },
    {
      "R",
      function()
        require("flash").treesitter_search()
      end,
      mode = { "o", "x" },
      desc = "Treesitter Search",
    },
    {
      "<C-s>",
      function()
        require("flash").toggle()
      end,
      mode = "c",
      desc = "Toggle Flash Search",
    },
    {
      "<C-Space>",
      function()
        require("flash").treesitter({
          actions = {
            ["<C-Space>"] = "next",
            ["<BS>"] = "prev",
          },
        })
      end,
      mode = { "n", "x", "o" },
      desc = "Treesitter Incremental Selection",
    },
  },
}
