-- [[ AI Context ]]

-- Send editor context to a manually launched OpenCode instance
return {
  "nickjvandyke/opencode.nvim",
  branch = "main",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    {
      "<leader>aa",
      function()
        require("opencode").ask("@this: ")
      end,
      mode = { "n", "x" },
      desc = "Ask OpenCode",
    },
    {
      "<leader>as",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "OpenCode Actions",
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Manually run OpenCode TUI in a separate tmux panel/window
      server = { start = false },
      events = {
        -- Keep permission requests and edit approval in the OpenCode TUI
        permissions = { enabled = false, edits = { enabled = false } },
      },
    }
  end,
}
