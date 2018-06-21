os.loadAPI("/git/scripts/functions")
os.loadAPI('/git/data/fingerprints')


print("plap")

local soulsandSlots = {}
local witherSlots = {}
local detail
local countersoulsand = 1
local counterwitherslots = 1

for i = 1, 16, 1 do
  detail = turtle.getItemDetail(i)

  if detail == nil then
  else
    if (detail.name == fingerprints.soulsand.id)  then
      print("foundone")
      soulsandSlots[countersoulsand] = detail
      soulsandSlots[countersoulsand].index = i
      countersoulsand = countersoulsand + 1
    end
    if (detail.name == fingerprints.witherskull.id)  then
      witherSlots[counterwitherslots] = detail
      witherSlots[counterwitherslots].index = i
      counterwitherslots = counterwitherslots + 1
    end
  end
end


function placeBlockBehind()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.place()
  turtle.turnLeft()
  turtle.turnLeft()
end

function placeBlocksOnLeftAndRightSides()
  turtle.turnLeft()
  turtle.place()
  turtle.turnRight()
  turtle.turnRight()
  turtle.place()
  turtle.turnLeft()
end

function getIndexSoulSand()
  local numberinslot
  for i = 1, #soulsandSlots, 1 do
    numberinslot = turtle.getItemCount(soulsandSlots[i].index)
    if numberinslot > 7 then
      return soulsandSlots[i].index
    end
  end
  return 0
end

function getIndexWither()
  local numberinslot
  for i = 1, #witherSlots, 1 do
    numberinslot = turtle.getItemCount(witherSlots[i].index)
    if numberinslot > 2 then
      return witherSlots[i].index
    end
  end
  return 0
end


local loopBoolean = true
local currentSoulSandSlot

while loopBoolean do

  currentSoulSandSlot = getIndexSoulSand()
  currentWitherSlot = getIndexWither()

  if currentSoulSandSlot == 0 or currentWitherSlot == 0 then
    print("Out of resources")
    os.exit()
  end
  
  turtle.select(currentSoulSandSlot)
  placeBlocksOnLeftAndRightSides()
  turtle.up()
  turtle.placeDown()
  placeBlocksOnLeftAndRightSides()
  	turtle.forward()
    placeBlockBehind()
    turtle.placeDown()
    turtle.forward()
    placeBlockBehind()

    --Place wither skulls


    turtle.down()
    turtle.forward()
    turtle.forward()

end
