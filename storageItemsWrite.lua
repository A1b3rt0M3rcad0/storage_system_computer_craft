require("config")
require("storageUtils")

local nbt = peripheral.find(nbtStorage)

while true do
    listItems = Items(tradeChest, nbtStorage)
    nbt.writeTable(listItems)
end