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
    -- select tokyonight theme day or night
    local function theme_colors()
      return require("tokyonight.colors").setup({
        style = vim.o.background == "light" and "day" or "night",
      })
    end

    local colors = theme_colors()

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
        -- Lualine re-evaluates this on colorscheme and background changes.
        theme = function()
          colors = theme_colors()
          return {
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
          }
        end,
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
            color = function()
              return { fg = colors.fg, bg = colors.bg, gui = "bold" }
            end,
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = function()
                return { fg = colors.green }
              end,
              modified = function()
                return { fg = colors.orange }
              end,
              removed = function()
                return { fg = colors.red }
              end,
            },
            cond = conditions.screen_width(80),
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          },
        },
        lualine_x = {
          {
            "location",
            cond = conditions.buffer_not_empty,
          },
          "progress",
          "encoding",
          {
            "fileformat",
            fmt = string.lower,
            icons_enabled = false,
          },
          "filetype",
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
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
