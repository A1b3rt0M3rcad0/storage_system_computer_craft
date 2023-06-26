require("config")
require("storageUtils")

while true do
    depositItems(depositChest, storageItemsExcludChests)
    sleep(0.5)
end