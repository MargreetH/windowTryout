--Functions used by the ME program

--Fills the whole chest with items
function fillChest(interface, side)
  --local stacksTable
  --stacksTable = interface.getAllStacks(false)

  local canExportToSide
  canExportToSide = interface.canExport("north")
  print(canExportToSide)

end
