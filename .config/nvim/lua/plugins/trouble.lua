-- [[ Diagnostics List ]]

-- Navigate Trouble when open and preserve native quickfix motions otherwise
local function list_jump(direction)
  return function()
    if require("trouble").is_open() then
      vim.cmd("Trouble " .. direction .. " jump=true")
      return
    end

    local command = direction == "next" and vim.cmd.cnext or vim.cmd.cprev
    local ok, err = pcall(command)
    if not ok then
      vim.notify(tostring(err), vim.log.levels.ERROR)
    end
  end
end

-- Browse diagnostics, symbols, LSP results, and native editor lists
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
    { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP Results (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    { "[q", list_jump("prev"), desc = "Previous Trouble/Quickfix Item" },
    { "]q", list_jump("next"), desc = "Next Trouble/Quickfix Item" },
  },
}
