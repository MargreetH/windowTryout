local currentMovingDirection = {1, 0}
local currentPosition = {20, 7}
local snakeBlockCoordinates = {}
snakeBlockCoordinates[1] = currentPosition
snakeBlockCoordinates[2] = {19, 7}
snakeBlockCoordinates[3] = {18, 7}
local snakeBlockWindows = {}


function createSnakeBlock(snakeblockcoordinates)
  index = #snakeBlockCoordinates + 1
  snakeBlockWindows[index] = window.create(term, snakeBlockCoordinates[1], snakeBlockCoordinates[2], 1, 1)
  snakeBlockWindows[index].setBackgroundColor(1)
  snakeBlockWindows[index].clear()
end

--Create first few blocks
createSnakeBlock(snakeBlockCoordinates[1])
createSnakeBlock(snakeBlockCoordinates[2])
createSnakeBlock(snakeBlockCoordinates[3])

function touchEvent(xPos, yPos)

end


function processEvents(event)

  if event[1] == "monitor_touch" then
    touchEvent(event[3], event[4])
  else if event[1] == "key" then
    functions.printTableToTerminal(event)
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

print("plap")

function nextStep()
  term.clear()


end


local mainBoolean = true

while mainBoolean do

  wait(0.2)
end
