os.loadAPI("/git/scripts/functions")

local currentMovingDirection = {}
currentMovingDirection[1] = 1
currentMovingDirection[2] = 0
local snakeBlockWindows = {}
local powerUpWindows = {}
local score = 0
local waitingTime = 0.1

local maxX, maxY = term.native().getSize()
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
  reDrawAllStuff()
  term.native().clear()
  local cursorpos = maxY+1
  term.native().setCursorPos(1, cursorpos)
  term.native().setTextColor(1)
  term.native().write("Score: "..score)


  if score > 3 then
    waitingTime = 0.2
  elseif score > 5 then
    waitingTime = 0.15
  elseif score > 10 then
    waitingTime = 0.12
  elseif score > 20 then
    waitingTime = 0.11
  elseif score > 50 then
    waitingTime = 0.05
  elseif score > 100 then
    waitingtime = 0.01
  end

end


function doNotEscapeScreen(x,y)
  local newx
  local newy
  newx = x
  newy = y
  if x > maxX then newx = 1 end
  if y > maxY then newy = 1 end
  if x == 0 then newx = maxX end
  if y == 0 then newy = maxY end
  return newx, newy
end

function createPowerUp(x,y)
  local index = #powerUpWindows + 1
  powerUpWindows[index] = window.create(term.native(), x, y, 1, 1)
  powerUpWindows[index].setBackgroundColor(2)
  powerUpWindows[index].clear()
end


function createSnakeBlock(x,y)
  local index = #snakeBlockWindows + 1
  snakeBlockWindows[index] = window.create(term.native(), x, y, 1, 1)
  snakeBlockWindows[index].setBackgroundColor(1)
  snakeBlockWindows[index].clear()
  reDrawAllStuff()
end

function checkIfInsideSnake(x,y)
  for i = 1, #snakeBlockWindows, 1 do
    local snakex, snakey = snakeBlockWindows[i].getPosition()
    if (snakex == x) and (snakey == y) then
      return true
    end
  end

  return false
end

function checkIfPowerUp(x,y)
  for i = 1, #powerUpWindows, 1 do
    local xx, yy = powerUpWindows[i].getPosition()
    if (xx == x) and (yy == y) then
      return i
    end
  end

  return false
end

function drawSnakeHead()
  snakeBlockWindows[1].setTextColor(32768)
  functions.textInMiddleButton(snakeBlockWindows[1],"..")
end



--Create first few blocks
createSnakeBlock(20,7)
createSnakeBlock(19,7)
createSnakeBlock(18,7)

createPowerUp(2,2)

drawSnakeHead()


function addBlockAtTail()
  local lengthOfSnake = #snakeBlockWindows
  local lastBlock = snakeBlockWindows[lengthOfSnake]
  local secondLastBlock = snakeBlockWindows[lengthOfSnake - 1]
  local xlast, ylast = lastBlock.getPosition()
  local xsecondlast, ysecondlast = secondLastBlock.getPosition()

  local xdifference = xlast - xsecondlast
  local ydifference = ylast - ysecondlast
  local newx = xlast - xdifference
  local newy = ylast - ydifference
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
    local randomx = math.random(maxX)
    local randomy = math.random(maxY)
    bool2 = checkIfInsideSnake(randomx, randomy)
    bool3 = checkIfPowerUp(randomx, randomy)

    if (bool2 == false) and (bool3 == false) then
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
  elseif keycode == 205 then --right
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

local mainBoolean = true
local doesThePowerUpSpawn


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

  --Check if we meet ourselves
  local areWeInside
  areWeInside = checkIfInsideSnake(x,y)
  if areWeInside then
    mainBoolean = false
    local t = term.native()
    t.setCursorPos(3,5)
    t.setTextColor(16384)
    t.write("GAME OVER!")
    return
  end

  local willPickupPowerup
  willPickupPowerup = checkIfPowerUp(x,y)

  if willPickupPowerup == false then
    --nothing
  else
    pickedUpPowerUp(willPickupPowerup)
  end



  snakeBlockWindows[1].reposition(x,y)
  term.native().clear()
  reDrawAllStuff()
end

--rewriteScore()




while mainBoolean do


  wait(waitingTime)
  nextStep()

  doesThePowerUpSpawn = math.random(100)
  if doesThePowerUpSpawn > 97 then
    spawnRandomPowerup()
  end
  addBlockAtTail()
end

wait(3)
