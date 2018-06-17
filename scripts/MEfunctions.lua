os.loadAPI("/git/scripts/functions")

--Functions used by the ME program


--Returns all of the hashes that respond to a given id
function returnNBThashes(itemid, itemlist)
  local NBThashes
  NBThashes = {}
  local counter = 1
  print("Size of itemlist: "..#itemlist)
    for i = 1, #itemlist, 1 do
      if (itemlist[i].fingerprint.id == itemid) and (itemlist[i].fingerprint.nbt_hash ~= nil) and (itemlist[i].fingerprint.nbt_hash ~= "") then
        	NBThashes[counter] = itemlist[i].fingerprint.nbt_hash
          counter = counter + 1
          functions.printTableToTerminal(itemlist[i])
          functions.printTableToTerminal(itemlist[i].fingerprint)
      end
    end
  print("Amount of matches found:"..counter)
  return NBThashes
end

--Fills the whole chest with items
function fillChest(interface, side, sizeChest, fingerprint, amount)

  local itemsToBeTransported
  itemsToBeTransported = amount
  local canExportToSide
  canExportToSide = interface.canExport(side)

  if canExportToSide == false then
    print("Couldn't export to side "..side.." item "..fingerprint.id)
    return
  end

  local counter1
  counter1 = 1
  local returnedTable
  local notDoneTransporting
  notDoneTransporting = true

  while notDoneTransporting do
    local returnedTable
    returnedTable = interface.exportItem(fingerprint, side, itemsToBeTransported, counter1)

    if (returnedTable ~= nil) and (returnedTable["size"] ~= nil) then
      itemsToBeTransported = itemsToBeTransported - tonumber(returnedTable["size"])
    end

    counter1 = counter1 + 1

    if counter1 > sizeChest then counter1 = 1 end
    if itemsToBeTransported == 0 then notDoneTransporting = false end
    sleep(0.5)
  end



end
