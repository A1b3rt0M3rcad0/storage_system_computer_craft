-- retorna True se o item contem na tabela e falso se não
function table.contains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

-- retorna todos os baus do sistema sem contar os sideChests
function getChests(excludedPeripherals)
    local finalTable = {}
    local excludedPeripherals = excludedPeripherals
    local tbl = peripheral.getNames()
    for _, chest in pairs(tbl) do
        if not table.contains(excludedPeripherals, chest) then
            table.insert(finalTable, chest)
        end
    end
    return finalTable
end

-- retorna uma lista que contem [Item][Chest] = quantidade, além de  [Item][maxCount] = Count e  [Item][totalCount] = Count 
function Items(tradeChest, nbtStorage)

    local excludedPeripherals = {'left', 'back', 'right', 'front', 'top', 'bottom', tradeChest, nbtStorage}
    local storage = {}
    local chests = peripheral.getNames()
    for _, chest in ipairs(chests) do
        if not table.contains(excludedPeripherals, chest) then
            local storageChest = peripheral.wrap(chest)
            for slot, item in pairs(storageChest.list()) do
                local itemCount = item.count
                local itemDetail = storageChest.getItemDetail(slot)
                local itemName = itemDetail.displayName
                local itemMaxCount = itemDetail.maxCount
                if storage[itemName] then
                    if storage[itemName][chest] then
                        storage[itemName][chest] = storage[itemName][chest] + itemCount
                        storage[itemName].totalCount = storage[itemName].totalCount + itemCount
                    else 
                        storage[itemName][chest] = {}
                        storage[itemName][chest] = itemCount
                        storage[itemName].totalCount = storage[itemName].totalCount + itemCount
                    end
                else
                    storage[itemName] = {}
                    storage[itemName][chest] = itemCount
                    storage[itemName].totalCount = itemCount
                    storage[itemName].maxCount = itemMaxCount
                end
            end
        end
    end
    return storage
end

-- retorna uma lista com 3 listas 1 com os baus que possui o item e quantos itens tem no bau, 2 com o total do item no sistema
-- e 3 com o maximo stack do item
-- se não encontra o item retorna uma lista de tabelas vazias
function searchItem(listItems, itemNameTerm)

    local itemChests = {}
    local itemCount = {}
    local itemMaxCount = {}
    local itemId = {}
    local itemNameLowerTerm = string.lower(itemNameTerm)

    for itemName, itemInfo in pairs(listItems) do
        local itemNameLower = string.lower(itemName)
        if string.find(itemNameLower, itemNameLowerTerm) then
            itemChests[itemName] = {}
            itemCount[itemName] = {}
            itemMaxCount[itemName] = {}
            for Info, Count in pairs(itemInfo) do
                if not table.contains({"maxCount", "totalCount"}, Info) then
                    itemChests[itemName][Info] = Count
                elseif table.contains({"totalCount"}, Info) then             
                    itemCount[itemName][Info] = Count
                else
                    itemMaxCount[itemName][Info] = Count
                end
                id = 1
                for item, _ in pairs(itemChests) do
                    itemId[id] = item
                    id = id + 1
                end
            end
        end
    end
    return {itemChests, itemCount, itemMaxCount, itemId}
end

-- saca o item de uma tabela de baus do searchItem() é necessario o nome completo do item, o bau para onde ele vai e a quantidade
-- não a restrição de saque, se o item estiver no sistema com x e você sacar mais que X ele apenas ira sacar o X sem erro.
function withdrawItem(tableItems, itemName, chestTo, count)
    local Item = tableItems[itemName]
    if Item then
        local Transferred = 0
        for Chest, _ in pairs(Item) do
            local storageChest = peripheral.wrap(Chest)
            for Slot, Item in pairs(storageChest.list()) do
                local name = storageChest.getItemDetail(Slot).displayName
                local storageItemCount = Item.count
                local Missing = count - Transferred
                if name == itemName then
                    if Missing >= storageItemCount then
                        storageChest.pushItems(chestTo, Slot, storageItemCount)
                        Transferred = Transferred + storageItemCount
                    else
                        storageChest.pushItems(chestTo, Slot, Missing)
                        Transferred = Transferred + Missing
                    end
                end
                if Transferred >= count then
                    break
                end
            end
            if Transferred >= count then
                break
            end
        end
    end
end

-- Escolha o baú ChestTrade de onde será retirado os itens, e passe a lista de exludepreipherals para
-- Escolher os baus que não pode ser depositados
function depositItems(chestTrade, excludedPeripherals)

    local chestTrade = peripheral.wrap(chestTrade)

    for Slot, _ in pairs(chestTrade.list()) do
        local listChests = getChests(excludedPeripherals)
        for _, chestName in pairs(listChests) do
            local chest = peripheral.wrap(chestName)
            chest.pullItems(peripheral.getName(chestTrade), Slot)
        end
    end
end


-- Le a tabela que esta armazenada no NBT e retorna a tabela
function readNBT(nbts)
    local nbt = peripheral.find(nbts)
    local table = nbt.read()
    return table
end
