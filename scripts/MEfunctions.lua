os.loadAPI("/git/scripts/functions")
--Functions used by the ME program


--Returns all of the hashes that respond to a given id
function returnNBThashes(itemid, itemlist)

local numberofItems = #itemlist
local NBThashes
NBThashes = {}
local counter = 1

  for i = 1, numberOfItems, 1 do
  if itemlist[i].fingerprint.id == itemid then
    	NBThashes[counter] = itemlist[i].fingerprint.nbt_hash
      counter = counter + 1
  end
  return NBThashes
end

end

--Fills the whole chest with items
function fillChest(interface, side, sizeChest, fingerprint)
  --local stacksTable
  --stacksTable = interface.getAllStacks(false)



  local itemToBeTransported


  local canExportToSide
  canExportToSide = interface.canExport(side)

  local counter1
  counter1 = 1
  local returnedTable
  local succeeded

  while canExportToSide do
    returnedTable = interface.exportItem(fingerprint, side, 64, counter1)
    canExportToSide = interface.canExport(side)
    counter1 = counter1 + 1
    succeeded = returnedTable["size"]
    print(succeeded)
    sleep(3)
        if counter1 > 1 then canExportToSide = false end
  end



end
