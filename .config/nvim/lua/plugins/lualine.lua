-- [[ Statusline ]]

-- Display editor state, Git context, diagnostics, and file details
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- Keep an empty statusline visible until Lualine loads
      vim.o.statusline = " "
    else
      -- Hide the statusline while the dashboard starts
      vim.o.laststatus = 0
    end
  end,

  -- Build a minimal statusline around the active colorscheme
  opts = function()
    local colors = require("tokyonight.colors").setup({ style = "night" })

    -- Build colors for the active mode section
    local function mode_a(bg)
      return { bg = bg, fg = colors.black, gui = "bold" }
    end

    -- Keep the center section on the base theme colors
    local function mode_c()
      return { fg = colors.fg, bg = colors.bg }
    end

    -- Hide context-sensitive components when they are not useful
    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      screen_width = function(min_w)
        return function()
          return vim.o.columns > min_w
        end
      end,
    }

    -- Restore the user's statusline setting before Lualine renders
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      -- Keep the statusline minimal and hide it on the dashboard
      options = {
        globalstatus = vim.o.laststatus == 3,
        component_separators = "",
        section_separators = "",
        disabled_filetypes = {
          statusline = { "snacks_dashboard" },
        },
        theme = {
          normal = {
            a = mode_a(colors.blue),
            c = mode_c(),
          },
          insert = {
            a = mode_a(colors.green),
            c = mode_c(),
          },
          command = {
            a = mode_a(colors.yellow),
            c = mode_c(),
          },
          visual = {
            a = mode_a(colors.magenta),
            c = mode_c(),
          },
          replace = {
            a = mode_a(colors.red),
            c = mode_c(),
          },
          terminal = {
            a = mode_a(colors.teal),
            c = mode_c(),
          },
          inactive = {
            a = { bg = colors.bg, fg = colors.fg_dark },
            c = { fg = colors.fg_dark, bg = colors.bg },
          },
        },
      },

      -- Show Git, diagnostics, and filename on the left with file details on the right
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
          },
        },
        lualine_b = {},
        lualine_c = {
          {
            "branch",
            icon = "",
            color = { fg = colors.fg, bg = colors.bg, gui = "bold" },
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.orange },
              removed = { fg = colors.red },
            },
            cond = conditions.screen_width(80),
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          },
          {
            "filename",
            path = 0,
            cond = conditions.buffer_not_empty,
          },
        },
        lualine_x = {
          {
            "location",
            cond = conditions.buffer_not_empty,
          },
          "progress",
          "encoding",
          "filetype",
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
