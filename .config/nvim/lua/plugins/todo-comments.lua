-- [[ Todo Comments ]]

-- Search from the current Git root, falling back to the working directory
local function project_root()
  return Snacks.git.get_root() or vim.uv.cwd() or "."
end

-- Highlight and browse project TODO comments
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next Todo Comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous Todo Comment",
    },
    {
      "<leader>st",
      function()
        Snacks.picker.pick("todo_comments", { cwd = project_root() })
      end,
      desc = "Todo",
    },
    {
      "<leader>sT",
      function()
        Snacks.picker.pick("todo_comments", {
          cwd = project_root(),
          keywords = { "TODO", "FIX", "FIXME" },
        })
      end,
      desc = "Todo/Fix/Fixme",
    },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    {
      "<leader>xT",
      "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
      desc = "Todo/Fix/Fixme (Trouble)",
    },
  },
}
