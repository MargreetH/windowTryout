os.loadAPI("/git/scripts/functions")
--Functions used by the ME program


--Returns all of the hashes that respond to a given id
function returnNBThashes(itemid, itemlist)
  local NBThashes
  NBThashes = {}
  local counter = 1
  print(#itemlist)
    for i = 1, #itemlist, 1 do
      if (itemlist[i].fingerprint.id == itemid) and (itemlist[i].fingerprint.nbt_hash ~= nil) and (itemlist[i].fingerprint.nbt_hash ~= "") then
        	NBThashes[counter] = itemlist[i].fingerprint.nbt_hash
          counter = counter + 1
          print(itemlist[i].fingerprint.nbt_hash)
      end
    end
  return NBThashes
end

--Fills the whole chest with items
function fillChest(interface, side, sizeChest, fingerprint, amount)

  local itemsToBeTransported
  itemToBeTransported = amount

  local canExportToSide
  canExportToSide = interface.canExport(side)

  local counter1
  counter1 = 1
  local returnedTable
  local numberSuccesfullyTransported
  numberSuccesfullyTransported = 0
  local transportStack
  local notDoneTransporting
  notDoneTransporting = true

  while notDoneTransporting do
    returnedTable = interface.exportItem(fingerprint, side, itemsToBeTransported, counter1)
    itemsToBeTransported = itemsToBeTransported - returnedTable["size"]
    counter1 = counter1 + 1

    if counter1 > sizeChest then counter1 = 1 end
    if itemsToBeTransported == 0 then notDoneTransporting = false end
    sleep(2)
  end



end
