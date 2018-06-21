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
      countersoulsand = countersoulsand + 1
      soulsandSlots[countersoulsand].index = i
    end
    if (detail.name == fingerprints.witherskull.id)  then
      witherSlots[counterwitherslots] = detail
      counterwitherslots = counterwitherslots + 1
      witherSlots[counterwitherslots].index = i
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


local loopBoolean = true

while loopBoolean do

  turtle.select(soulsandSlots[1].index)
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
