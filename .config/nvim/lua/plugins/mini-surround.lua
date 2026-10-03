-- [[ Surround Editing ]]

-- Edit surrounding pairs with the gs prefix to coexist with Flash
return {
  "nvim-mini/mini.surround",
  keys = {
    { "gsa", desc = "Add Surrounding", mode = { "n", "x" } },
    { "gsd", desc = "Delete Surrounding" },
    { "gsr", desc = "Replace Surrounding" },
    { "gsf", desc = "Find Right Surrounding", mode = { "n", "x", "o" } },
    { "gsF", desc = "Find Left Surrounding", mode = { "n", "x", "o" } },
    { "gsh", desc = "Highlight Surrounding" },
  },
  opts = {
    mappings = {
      add = "gsa",
      delete = "gsd",
      replace = "gsr",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      suffix_last = "l",
      suffix_next = "n",
    },
  },
}
