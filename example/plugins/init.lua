local overrides = require "custom.plugins.overrides"

return {
    ["folke/which-key.nvim"] = {
    disable = false,
  },
   ["goolord/alpha-nvim"] = {
    disable = false,
  },
  ["SigmaNvim/UI"] = {
     statusline = {
       separator_style = "round", -- default/round/block/arrow
       overriden_modules = nil,
     },
     tabufline = {
       enabled = true,
       lazyload = true,
       overriden_modules = nil,
     },
   },
}

