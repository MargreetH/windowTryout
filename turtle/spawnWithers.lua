os.loadAPI("/git/scripts/functions")
os.loadAPI('/git/data/fingerprints')


print("plap")

local soulsandSlots = {}
local witherSlots = {}
local allSlotDetails = {}


for i = 1, 16, 1 do
  allSlotDetails[i] = turtle.getItemDetail(i)
end

local countersoulsand = 1
local counterwitherslots = 1


function getTotalAmountOfWitherSkulls()


end


--Check where the soulsand and wither skulls are
for i = 1, #allSlotDetails, 1 do
  if (allSlotDetails[i].id == fingerprints.soulsand.id)  then
    soulsandSlots[countersoulsand] = i
    countersoulsand = countersoulsand + 1
  end
  if (allSlotDetails[i].id == fingerprints.witherskull.id)  then
    witherSlots[counterwitherslots] = i
    counterwitherslots = counterwitherslots + 1
  end
end

functions.printTableToTerminal(soulsandSlots)


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


local loopBoolean = false

while loopBoolean do

  turtle.select(soulsandSlots[1])
  placeBlocksOnLeftAndRightSides()
  turtle.up()
  turtle.placeDown()
  placeBlocksOnLeftAndRightSides()
  	turtle.forward()
    placeBlockBehind()
    turtle.placeDown()
    turtle.forward()
    placeBlockBehind()
    turtle.down()
    turtle.forward()
    turtle.forward()

end
