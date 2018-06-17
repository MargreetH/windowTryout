--Functions used by the ME program

--Fills the whole chest with items
function fillChest(interface)
  local stacksTable
  stacksTable = interface.getAllStacks(false)
  for i = 1, #stacksTable do
  print(stacksTable[i])
end
end
