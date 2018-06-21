os.loadAPI("/git/scripts/functions")
os.loadAPI('/git/data/fingerprints')


print("plap")

local soulsandSlots = {}
local witherSlots = {}
local allSlotDetails = {}
local detail

for i = 1, 16, 1 do
  detail = turtle.getItemDetail(i)
  if (detail.id == fingerprints.soulsand.id)  then
    print("foundone")
    soulsandSlots[countersoulsand] = detail
    countersoulsand = countersoulsand + 1
    soulsandSlots[countersoulsand].index = i
  end
  if (detail.id == fingerprints.witherskull.id)  then
    witherSlots[counterwitherslots] = detail
    counterwitherslots = counterwitherslots + 1
    witherSlots[counterwitherslots].index = i
  end
end

local countersoulsand = 1
local counterwitherslots = 1


function getTotalAmountOfWitherSkulls()


end


--Check where the soulsand and wither skulls are
for i = 1, #allSlotDetails, 1 do


end

functions.printTableToTerminal(soulsandSlots[1])


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
