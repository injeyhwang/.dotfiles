-- [[ Indentation Guides ]]

-- Show indentation and scope guides without markers at scope boundaries
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = {
      char = "▏",
      tab_char = "▏",
    },
    scope = {
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        "Trouble",
        "help",
        "lazy",
        "mason",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_terminal",
        "snacks_win",
        "trouble",
      },
    },
  },
}
