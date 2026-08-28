-- [[ Snacks ]]

-- Search from the current Git root, falling back to the working directory
local function project_root()
  return Snacks.git.get_root() or vim.uv.cwd() or "."
end

-- Provide the startup dashboard and interactive pickers
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    -- Navigate files, buffers, and picker history
    {
      "<leader><space>",
      function()
        Snacks.picker.smart({ cwd = project_root() })
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep({ cwd = project_root() })
      end,
      desc = "Grep",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>e",
      function()
        Snacks.explorer({ cwd = project_root() })
      end,
      desc = "File Explorer",
    },

    -- Find files
    {
      "<leader>ff",
      function()
        Snacks.picker.files({ cwd = project_root() })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },

    -- Search editor and project state
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep({ cwd = project_root() })
      end,
      desc = "Grep",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word({ cwd = project_root() })
      end,
      mode = { "n", "x" },
      desc = "Visual Selection or Word",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics({ cwd = project_root() })
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },

    -- Browse changed files in the current repository
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status({ cwd = project_root() })
      end,
      desc = "Git Status",
    },
  },
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = [[
                                                                    
      ████ ██████           █████      ██                     
     ███████████             █████                             
    █████████ ███████████████████ ███   ███████████   
   █████████  ███    █████████████ █████ ██████████████   
  █████████ ██████████ █████████ █████ █████ ████ █████   
 ███████████ ███    ███ █████████ █████ █████ ████ █████  
██████  █████████████████████ ████ █████ █████ ████ ██████ 
        ]],
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "Find File",
            action = ":lua Snacks.dashboard.pick('files')",
          },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = ":lua Snacks.dashboard.pick('live_grep')",
          },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua Snacks.dashboard.pick('oldfiles')",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    explorer = { enabled = true },

    -- Keep Flash jumps scoped to picker result rows
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<A-s>"] = { "flash", mode = { "n", "i" } },
            ["s"] = { "flash" },
          },
        },
      },
      actions = {
        ---@param picker snacks.Picker
        flash = function(picker)
          require("flash").jump({
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
              mode = "search",
              exclude = {
                function(window)
                  return vim.bo[vim.api.nvim_win_get_buf(window)].filetype ~= "snacks_picker_list"
                end,
              },
            },
            action = function(match)
              picker.list:view(picker.list:row2idx(match.pos[1]))
            end,
          })
        end,
      },
    },

    -- disable snacks indent when indent-blankline is enabled
    indent = { enabled = false },
  },
}
