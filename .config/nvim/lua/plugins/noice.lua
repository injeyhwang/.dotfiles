-- [[ Command Line and Messages ]]

-- Present command-line input, messages, and notifications through one UI
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      main = "notify",
      opts = {
        top_down = true,
      },
    },
  },
  opts = {
    messages = {
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
    },
    notify = {
      view = "notify",
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          find = "%d+L, %d+B",
        },
        view = "notify",
        opts = { title = "Saved" },
      },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },
  keys = {
    {
      "<S-Enter>",
      function()
        require("noice").redirect(vim.fn.getcmdline())
      end,
      mode = "c",
      desc = "Redirect Cmdline",
    },
    { "<leader>snl", "<cmd>Noice last<cr>", desc = "Noice Last Message" },
    { "<leader>snh", "<cmd>Noice history<cr>", desc = "Noice History" },
    { "<leader>sna", "<cmd>Noice all<cr>", desc = "Noice All Messages" },
    { "<leader>snd", "<cmd>Noice dismiss<cr>", desc = "Dismiss Noice Messages" },
    { "<leader>snp", "<cmd>Noice pick<cr>", desc = "Noice Message Picker" },
  },
}
