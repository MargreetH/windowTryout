--Functions used by the ME program

--Fills the whole chest with items
function fillChest(interface)
  local stacksTable
  stacksTable = interface.getAllStacks(false)
  print(stacksTable[1])
end
