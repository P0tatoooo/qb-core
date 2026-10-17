-- The clothing lists of shared/main.lua (gloves, big bags, bulletproof vests), from the server's
-- GlobalState.clothingLists (server/clothinglists.lua): the current ones on join, and every change saved
-- from MyCity_AdminMenu.
QBShared.ApplyClothingLists(GlobalState.clothingLists)

AddStateBagChangeHandler('clothingLists', 'global', function(_, _, value)
    QBShared.ApplyClothingLists(value)
end)
