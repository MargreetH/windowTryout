--Functions used by the ME program

--Fills the whole chest with items
function fillChest(interface, side)
  --local stacksTable
  --stacksTable = interface.getAllStacks(false)


  local itemToBeTransported
  fingerprint = {id= "minecraft:coal", dmg = 0}

  local canExportToSide
  canExportToSide = interface.canExport(side)
  print(canExportToSide)


  local counter1
  counter1 = 1
  local returnedTable

  while canExportToSide do
    returnedTable = interface.exportItem(fingerprint, side, 64, counter1)
    canExportToSide = interface.canExport("north")
    counter1 = counter1 + 1
    print(returnedTable[1])
    print(returnedTable[2])
  end

end
