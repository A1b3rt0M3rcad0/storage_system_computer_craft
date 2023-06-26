require("config")
require("storageUtils")
require("searchItem")

local cc_require = require("cc.require")
local env = setmetatable({}, { __index = _ENV })
env.require, env.package = cc_require.make(env, "/")


multishell.launch(env, "/storage_1/storageAutoDeposit.lua")
multishell.launch(env, "/storage_1/storageItemsWrite.lua")

storageSystem(tradeChest)
