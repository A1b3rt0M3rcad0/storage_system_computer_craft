require("/storage_1/config")
require("/storage_1/storageUtils")

local nbt = peripheral.find(nbtStorage)

while true do
    listItems = Items(tradeChest, nbtStorage)
    nbt.writeTable(listItems)
end