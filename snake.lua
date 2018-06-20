os.loadAPI("/git/scripts/functions")

local currentMovingDirection = {1, 0}
local currentPosition = {20, 7}
local snakeBlockCoordinates = {}
snakeBlockCoordinates[1] = currentPosition
snakeBlockCoordinates[2] = {19, 7}
snakeBlockCoordinates[3] = {18, 7}
local snakeBlockWindows = {}
local powerUpWindows = {}

local maxX, maxY = term.getSize()
maxY = maxY - 1

function rewriteScore(score)
  term.clear()
  term.setCursorPos(1, maxY+1)
  term.setTextColor(1)
  term.write("Score: "..score)

  for i = 1, #snakeBlockWindows, 1 do
    snakeBlockWindows[i].redraw()
  end

  for i = 1, #powerUpWindows, 1 do
    powerUpWindows[i].redraw()
  end
end


function doNotEscapeScreen(x,y)
  local newx
  local newy
  if x > maxX then newx = 1 end
  if y > maxX then newy = 1 end
  if x < 0 then newx = maxX end
  if y < 0 then newx = maxY end
  return newx, newy
end

function createPowerUp(x,y)
  index = #powerUpWindows + 1
  snakeBlockWindows[index] = window.create(term.current(), x, y, 1, 1)
  snakeBlockWindows[index].setBackgroundColor(4)
  snakeBlockWindows[index].clear()
end


function createSnakeBlock(snakeblockcoordinates)
  index = #snakeBlockWindows + 1
  snakeBlockWindows[index] = window.create(term.current(), snakeBlockCoordinates[1], snakeBlockCoordinates[2], 1, 1)
  snakeBlockWindows[index].setBackgroundColor(1)
  snakeBlockWindows[index].clear()
end

function checkIfInsideSnake(x,y)
  for i = 1, #snakeBlockWindows, 1 do
    snakex, snakey = snakeBlockWindows[i].getPosition()
    if (snakex == x) and (snakey == y) then
      return true
    end
  end

  return false
end

function checkIfPowerUp(x,y)
  for i = 1, #powerUpWindows, 1 do
    xx, yy = powerUpWindows[i].getPosition()
    if (xx == x) and (yy == y) then
      return i
    end
  end

  return false
end

--Create first few blocks
createSnakeBlock(snakeBlockCoordinates[1])
createSnakeBlock(snakeBlockCoordinates[2])
createSnakeBlock(snakeBlockCoordinates[3])

function addBlockAtTail()
  local lengthOfSnake = #snakeBlockWindows
  local lastBlock = snakeBlockWindows(lengthOfSnake)
  local secondLastBlock = snakeBlockWindows(lengthOfSnake - 1)
  local xlast, ylast = lastBlock.getPosition()
  local xsecondlast, ysecondlast = secondLastBlock.getPosition()

  local xdifference = xlast - xsecondlast
  local ydifference = ylast - ysecondlast
  local newx = xlast + xdifference
  local newy = ylast + xdifference
  newx, newy = doNotEscapeScreen(newx,newy)
  local coords = {newx, newy}
  createSnakeBlock(coords)
end

function pickedUpPowerUp(index)
  powerUpWindows[index].setVisible(false)
  powerUpWindows = functions.removeFromtable(powerUpWindows, index)
  addBlockAtTail()
end

function spawnRandomPowerup()

  local randomx
  local randomy
  local bool = true

  while bool do
    randomx = math.random(maxX)
    randomY = math.random(maxY)
    bool2 = checkIfInsideSnake(randomx, randomy)

    if bool2 == false then
      createPowerUp(randomx, randomy)
      bool = false
    end
  end
end

function touchEvent(event)

end


function processEvents(event)
  if event[1] == "monitor_touch" then
    touchEvent(event[3], event[4])
  elseif event[1] == "key" then
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
  for i = 2, #snakeBlockWindows, 1 do
    local xx, yy = snakeBlockWindows[i-1].getPosition
    snakeBlockWindows.reposition(xx, yy)
  end

  local x, y = snakeBlockWindows[1].getPosition()

  x = x + currentMovingDirection[1]
  y = y + currentMovingDirection[2]

  x, y = doNotEscapeScreen(x,y)

  snakeBlockWindows[1].reposition(x,y)
  term.clear()
end

rewriteScore(0)


local mainBoolean = true

while mainBoolean do

  wait(0.2)
end
