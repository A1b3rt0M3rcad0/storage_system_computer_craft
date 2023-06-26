-- Obs não deixe nbtStorage em lado ao modem, coloque ao lado do computador
nbtStorage = "nbtStorage" -- nome do storage que será armazenado a lista de itens BNT advenced periphericals
tradeChest = "minecraft:chest_63" -- nome do bau que será efetuado as trocas do sistema
depositChest = "minecraft:chest_55" -- nome do bau em que será feito o deposito no sistema -- todo item aqui colocado será depositado
storageItemsExcludChests = {'left', 'back', 'right', 'front', 'top', 'bottom', tradeChest, nbtStorage} -- Lista de baús que não será lido no sistema para ser deposita
storageItemsExcludChests_2 = {'left', 'back', 'right', 'front', 'top', 'bottom', tradeChest, nbtStorage, depositChest} -- deposito startup