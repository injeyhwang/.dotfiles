-- [[ Git Signs ]]

-- Show Git changes in the sign column
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(buffer)
      local gitsigns = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buf = buffer, desc = desc, silent = true })
      end

      -- Navigate hunks while preserving native diff motions
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ vim.v.count1 .. "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ vim.v.count1 .. "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Previous Hunk")
      map("n", "]H", function()
        gitsigns.nav_hunk("last")
      end, "Last Hunk")
      map("n", "[H", function()
        gitsigns.nav_hunk("first")
      end, "First Hunk")

      -- Stage, reset, inspect, and select hunks
      map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage/Unstage Hunk")
      map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset Hunk")
      map("n", "<leader>ghS", gitsigns.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gitsigns.reset_buffer_index, "Unstage Buffer")
      map("n", "<leader>ghR", gitsigns.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gitsigns.preview_hunk_inline, "Preview Hunk")
      map("n", "<leader>ghb", function()
        gitsigns.blame_line({ full = true })
      end, "Blame Line")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Select Hunk")
    end,
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
}
