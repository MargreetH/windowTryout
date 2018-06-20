os.loadAPI("/git/scripts/functions")

local currentMovingDirection = {1, 0}
local snakeBlockWindows = {}
local powerUpWindows = {}
local score = 0

local maxX, maxY = term.getSize()
maxY = maxY - 1

function reDrawAllStuff()

  for i = 1, #snakeBlockWindows, 1 do
    snakeBlockWindows[i].redraw()
  end

  for i = 1, #powerUpWindows, 1 do
    powerUpWindows[i].redraw()
  end
end

function rewriteScore()
  term.clear()
  local cursorpos = maxY+1
  term.setCursorPos(1, cursorpos)
  term.setTextColor(1)
  term.write("Score: "..score)
  reDrawAllStuff()
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
  powerUpWindows[index] = window.create(term.current(), x, y, 1, 1)
  powerUpWindows[index].setBackgroundColor(4)
  powerUpWindows[index].clear()
end


function createSnakeBlock(x,y)
  index = #snakeBlockWindows + 1
  snakeBlockWindows[index] = window.create(term.current(), x, y, 1, 1)
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

function drawSnakeHead()
  snakeBlockWindows[1].setTextColor(32768)
  functions.textInMiddleButton(snakeBlockWindows[1],". .")
end



--Create first few blocks
createSnakeBlock(20,7)
createSnakeBlock(19,7)
--createSnakeBlock(18,7)

--drawSnakeHead()


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
  createSnakeBlock(newx, newy)
end

function pickedUpPowerUp(index)
  powerUpWindows[index].setVisible(false)
  powerUpWindows = functions.removeFromtable(powerUpWindows, index)
  addBlockAtTail()
  score = (score + 1)*2
  rewriteScore()
end

function spawnRandomPowerup()

  local randomx
  local randomy
  local bool = true
  local bool2

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

function keyEvent(keycode)
  if keycode == 208 then --down
    currentMovingDirection = {0,1}
  elseif keycode == 200 then --up
    currentMovingDirection = {0,-1}
  elseif keycode == 203 then --left
    currentMovingDirection = {-1,0}
  elseif keycode == 199 then --right
    currentMovingDirection = {1,0}
  end

end


function processEvents(event)
  if event[1] == "monitor_touch" then
    touchEvent(event[3], event[4])
  elseif event[1] == "key" then
    keyEvent(event[2])
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


function nextStep()
  for i = 2, #snakeBlockWindows, 1 do
    local index2 = i - 1
    local xx, yy = snakeBlockWindows[index2].getPosition()
    snakeBlockWindows[i].reposition(xx, yy)
  end

  local x, y = snakeBlockWindows[1].getPosition()

  x = x + currentMovingDirection[1]
  y = y + currentMovingDirection[2]

  x, y = doNotEscapeScreen(x,y)

  snakeBlockWindows[1].reposition(x,y)
  term.clear()
end

--rewriteScore()


local mainBoolean = true
local doesThePowerUpSpawn

while mainBoolean do
  nextStep()
  wait(1)

  doesThePowerUpSpawn = math.random(100)
  if doesThePowerUpSpawn > 95 then
    --spawnRandomPowerup()
  end
end
