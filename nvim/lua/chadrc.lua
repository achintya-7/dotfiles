-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  transparency = true,
}

M.term = {
  float = {
     relative = "editor",
     row = 0.1,
     col = 0.085,
     width = 0.8,
     height = 0.5,
     border = "double",
  }
}

return M
