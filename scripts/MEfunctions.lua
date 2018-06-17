--Functions used by the ME program

--Fills the whole chest with items
function fillChest(interface, chestLocation, fingerprint)
  stacksTable = getAllStacks(chestLocation)
  print(stacksTable[1])
end
