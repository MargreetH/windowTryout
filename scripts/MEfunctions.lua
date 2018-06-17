os.loadAPI("/git/scripts/functions")
--Functions used by the ME program

function processEvents(event)

  if event[1] == "monitor_touch" then
    touchEvent(event[3], event[4])
  end

end

local function wait (time)
  local timer = os.startTimer(time)
  while true do
    local event = {os.pullEvent()}
    if (event[1] == "timer" and event[2] == timer) then
      break
    else
      processEvents(event) -- a custom function in which you would deal with received events
    end
  end
end

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
