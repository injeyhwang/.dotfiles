-- [[ Basic Autocommands ]]

local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed outside of nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check for externally changed files",
  group = augroup("checktime"),
  callback = function()
    if vim.bo.buftype == "nofile" then
      return
    end

    vim.cmd("checktime")
  end,
})

-- Restore cursor to last known location when opening a file
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
  desc = "Restore last cursor location",
  group = augroup("last_loc"),
  callback = function(event)
    local buf = event.buf

    if vim.bo[buf].filetype == "gitcommit" then
      return
    end

    if vim.b[buf].config_last_loc then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)

    if mark[1] == 0 or mark[1] > line_count then
      return
    end

    local restored = false

    for _, window in ipairs(vim.fn.win_findbuf(buf)) do
      if vim.fn.win_gettype(window) ~= "autocmd" then
        local ok = pcall(vim.api.nvim_win_set_cursor, window, mark)
        restored = restored or ok
      end
    end

    if restored then
      vim.b[buf].config_last_loc = true
    end
  end,
})

-- Resize splits when the Neovim window is resized
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Resize splits equally when window is resized",
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()

    vim.cmd("tabdo wincmd =")

    vim.api.nvim_set_current_tabpage(current_tab)
  end,
})

-- Close selected special buffers with "q"
vim.api.nvim_create_autocmd("FileType", {
  desc = "Close selected filetypes with <q>",
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "gitsigns-blame",
    "help",
    "qf",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false

    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end

      vim.keymap.set("n", "q", function()
        pcall(vim.cmd.close)

        if vim.api.nvim_buf_is_valid(event.buf) then
          pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end
      end, { buf = event.buf, silent = true, desc = "Close special buffer" })
    end)
  end,
})

-- Make man pages unlisted when opened inline
vim.api.nvim_create_autocmd("FileType", {
  desc = "Unlist man buffers",
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Enable wrapping and spell checking for writing filetypes
vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable wrap and spell for writing filetypes",
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Disable automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable comment continuation on new lines",
  group = augroup("formatoptions"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Disable conceal for json filetypes
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable conceal for json filetypes",
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto-create missing parent directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto create missing parent directories on save",
  group = augroup("auto_create_dir"),
  callback = function(event)
    local uri = vim.uri_from_bufnr(event.buf)

    if not vim.startswith(uri, "file:") then
      return
    end

    local file = vim.uri_to_fname(uri)
    file = vim.uv.fs_realpath(file) or file

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})
