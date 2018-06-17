--Functions used by the ME program

--Fills the whole chest with items
function fillChest(interface, chestLocation, fingerprint)
  stacksTable = interface.getAllStacks(chestLocation)
  print(stacksTable[1])
end
