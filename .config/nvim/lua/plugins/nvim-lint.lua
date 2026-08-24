-- [[ Linting ]]

local events = { "BufReadPost", "BufWritePost" }

-- Build file context for linter conditions and working directories
local function get_context(buffer)
  local filename = vim.api.nvim_buf_get_name(buffer)
  return {
    filename = filename,
    dirname = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd(),
  }
end

-- Use the nearest SwiftLint config, falling back to stdin when none is found
local function swiftlint()
  local linter = require("lint.linters.swiftlint")()
  local context = get_context(0)
  local config = vim.fs.find(".swiftlint.yml", {
    path = context.dirname,
    upward = true,
  })[1]

  linter.cwd = config and vim.fs.dirname(config) or context.dirname
  if config then
    linter.args = {
      "lint",
      "--force-exclude",
      "--use-alternative-excluding",
      "--config",
      config,
    }
    linter.stdin = false
  else
    linter.args = { "lint", "--use-stdin" }
    linter.stdin = true
  end

  return linter
end

-- Merge table overrides while allowing complete linter replacements
local function configure_linters(lint, overrides)
  for name, override in pairs(overrides) do
    local linter = lint.linters[name]
    if type(linter) == "table" and type(override) == "table" then
      lint.linters[name] = vim.tbl_deep_extend("force", linter, override)
    else
      lint.linters[name] = override
    end
  end
end

-- Resolve filetype, fallback, and global linters without duplicates
local function resolve_linters(lint, context)
  local filetype = vim.bo.filetype
  local configured = lint.linters_by_ft[filetype]
  local names = vim.list_extend({}, configured or {})

  if not configured then
    for _, part in ipairs(vim.split(filetype, ".", { plain = true })) do
      vim.list_extend(names, lint.linters_by_ft[part] or {})
    end
  end

  if #names == 0 then
    vim.list_extend(names, lint.linters_by_ft["_"] or {})
  end

  vim.list_extend(names, lint.linters_by_ft["*"] or {})

  local seen = {}
  return vim.tbl_filter(function(name)
    if seen[name] then
      return false
    end
    seen[name] = true

    local linter = lint.linters[name]
    if not linter then
      vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
      return false
    end

    return type(linter) ~= "table" or not linter.condition or linter.condition(context)
  end, names)
end

-- Debounce lint events independently for each buffer
local function debounce(ms, callback)
  local generations = {}
  return function(event)
    local buffer = event.buf
    generations[buffer] = (generations[buffer] or 0) + 1
    local generation = generations[buffer]

    vim.defer_fn(function()
      if generations[buffer] ~= generation then
        return
      end
      generations[buffer] = nil

      if vim.api.nvim_buf_is_valid(buffer) and vim.api.nvim_buf_is_loaded(buffer) then
        callback(buffer)
      end
    end, ms)
  end
end

-- Run configured linters after reading and writing normal buffers
return {
  "mfussenegger/nvim-lint",
  event = events,
  opts = {
    events = events,
    debounce_ms = 100,
    linters_by_ft = {
      swift = { "swiftlint" },
      -- Use "_" as a fallback and "*" in addition to filetype linters
    },
    linters = {
      swiftlint = swiftlint,
    },
  },
  config = function(_, opts)
    local lint = require("lint")
    configure_linters(lint, opts.linters)
    lint.linters_by_ft = opts.linters_by_ft

    -- Lint only normal buffers with applicable linters
    local function lint_buffer(buffer)
      if vim.bo[buffer].buftype ~= "" then
        return
      end

      vim.api.nvim_buf_call(buffer, function()
        local context = get_context(buffer)
        local names = resolve_linters(lint, context)
        if #names > 0 then
          lint.try_lint(names)
        end
      end)
    end

    -- Debounce linting after reads and writes
    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("config_lint", { clear = true }),
      callback = debounce(opts.debounce_ms, lint_buffer),
    })
  end,
}
