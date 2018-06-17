os.loadAPI("/git/scripts/functions")
--Functions used by the ME program

--Fills the whole chest with items
function fillChest(interface, side)
  --local stacksTable
  --stacksTable = interface.getAllStacks(false)


  local itemToBeTransported
  fingerprint = {id= "minecraft:coal", dmg = 0}

  local canExportToSide
  canExportToSide = interface.canExport(side)

  local counter1
  counter1 = 1
  local returnedTable

  while canExportToSide do
    returnedTable = interface.exportItem(fingerprint, side, 64, counter1)
    canExportToSide = interface.canExport(side)
    counter1 = counter1 + 1
    if counter1 > 5 then canExportToSide = false end
    functions.printTableToTerminal(returnedTable)
    sleep(3)
  end



end
