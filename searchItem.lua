require("/storage_1/config")
require("/storage_1/storageUtils")

function banner()
    print("----------------------------------")
    print("---------","STORAGE SYSTEM","---------")
    print("----------------------------------")
end

function displayHome()
    banner()
    print("1 - Procurar/Sacar Item")
    print("2 - Depositar itens")
    print()
end

function displaySearch()
    banner()
    print("Digite o nome do item que deseja:")
    print()
end

function resetTerm()
    term.setCursorPos(1, 1)
    term.clear()
end

function storageSystem(chestTrade)

    while true do
        resetTerm()
        items = peripheral.find(nbtStorage).read()
        displayHome()
        local r = io.read()

        if r == "1" then
            while true do
                resetTerm()
                displaySearch()
                termo = io.read()
                local result = searchItem(items, termo)
                resetTerm()
                items = peripheral.find(nbtStorage).read()
                for id, item in pairs(result[4]) do
                    print(id, item, result[2][item].totalCount)
                end

                print("\n Qual dos items a seguir deseja sacar? [999] para sair")
                local idem = tonumber(io.read())

                if idem == 999 then
                    break
                end

                itemName = result[4][idem]
                print("\n Quantos itens deseja sacar?")
                local count = tonumber(io.read())
                print("\n Sacando ".. count .. " unidades de", itemName)
                withdrawItem(result[1], itemName, chestTrade, count)
                resetTerm()
                print("\n Deseja sacar mais itens? [n]")
                print("Ou digite qualquer coisa para continuar")
                local r = io.read()
                resetTerm()

                if r == 'n' then
                    break

                else
                    items = peripheral.find(nbtStorage).read()
                end

            end
        elseif r == '2' then
            print("Depositando itens....")
            depositItems(tradeChest, storageItemsExcludChests_2)
        else 
            print("\n Opção Invalida")
        end
    end
end