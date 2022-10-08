-- sigmarc overrides this file

local M = {}

M.options = {
  sigma = {
    update_url = "https://github.com/SigmaNvim/SigmaNvim.git",
    update_branch = "main",
  },
}

M.ui = {
  -- hl = highlights
  hl_add = {},
  hl_override = {},
  changed_themes = {},
  theme_toggle = { "onedark", "one_light" },
  theme = "onedark", -- default theme
  transparency = false,
}

M.plugins = {}

-- check core.mappings for table structure
M.mappings = require "core.mappings"

return M
