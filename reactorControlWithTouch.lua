local m
m = peripheral.wrap("right")
m.clear()
os.loadAPI("/git/scripts/functions")
local timeTick = 1

-- Some constants
energyTreshold = 2000000
justTurnedAllReactorsOff = false
offlineTime = 60
sleepTime = 3
local timeTick = 1
local numberOfReactors
local currentlyDisplaying = 1

-- Read settings file for reactor numbers
local reactorNumbers = {}
local reactorOnline = {}
local reactors = {}
local h  = fs.open("disk/reactorSettings", 'r')
local line = h.readLine()
counter1 = 1
while line ~= nil do
  reactorNumbers[counter1] = line
  reactorOnline[counter1] = true
  reactors[counter1] = peripheral.wrap("BigReactors-Reactor_"..reactorNumbers[counter1])
  line = h.readLine()
  counter1 = counter1 + 1
end
h.close()
local numberOfReactors = #reactors

-- ### WINDOWS
--Create all  windows
topPart = window.create(m, 1,1, 50, 4)
topPart.setCursorPos(1, 1)
infoField = window.create(m, 1,5, 50, 3)
infoField.setCursorPos(1, 1)
textField = window.create(m, 1,9, 50, 20)
createdWindows = functions.returnWindows(m, 1, 30, 50, 3, 3, true)
local switchButton = createdWindows[1]
local viewHistoryButton = createdWindows[2]
local exitButton = createdWindows[3]
textField.setBackgroundColor(32)
textField.clear()

--Set colors of buttons and such
switchButton.setBackgroundColor(2)
viewHistoryButton.setBackgroundColor(4)
exitButton.setBackgroundColor(8)
infoField.setBackgroundColor(1024)
infoField.clear()
textField.setTextColor(32768)
textField.setCursorPos(1, 1)
functions.fillButton(switchButton, "SWITCH")
functions.fillButton(viewHistoryButton, "VIEW HISTORY")
functions.fillButton(exitButton, "EXIT")

-- DRawing functions for all windows
function createTopPart(w)
  w.setBackgroundColor(16384) --Red
  w.setTextColor(32768) --Black
  w.write("****************************************************************")
  functions.newLine(w)
  w.write("***********  REACTOR CONTROL PROGRAM  ********************************")
  functions.newLine(w)
  w.write("****************************************************************")
  functions.newLine(w)
  w.setTextColor(64) --Pink
  w.setBackgroundColor(32768) --Black
  w.write("Written by Merlione404")
end

function drawInfoPart(w)
  w.clear()
  w.setCursorPos(1,1)
  w.write("Number of reactors monitored: "..tostring(numberOfReactors))
  functions.newLine(w)

  for i = 1, numberOfReactors, 1 do
    w.write("Reactor "..i)
    local isActive
    isActive = reactors[i].getActive()
      if isActive then
        w.setTextColor(8192) --Green
        w.write(" ACTIVE ")
      else
        w.setTextColor(16384) --red
        w.write(" OFFLINE ")
      end
    w.setTextColor(1)
  end

  functions.newLine(w)
  w.write("INFO PLACEHOLDER")
end

function getEnergyPercentage(energy)
  if energy == nil then
    return ""
  end
  if energy == 0 then
    return "0%"
  end
  maxEnergy = floor((energy / 10000000) * 100)
  return tostring(maxEnergy).."%"
end

function drawTextPart(w)
  w.clear()
  w.setCursorPos(1,1)
  local index = currentlyDisplaying
  w.setTextColor(32768) -- Black
  w.write("###########################################")
  functions.newLine(w)
  w.write("REACTOR "..index.." Press Switch button to view other reactors.")
  functions.newLine(w)
  w.write("###########################################")
  functions.newLine(w)
  functions.newLine(w)
  w.write("Number of control rods: "..reactors[index].getNumberOfControlRods())
  functions.newLine(w)
  w.write("Energy stored: "..reactors[index].getEnergyStored().." RF")
  w.write("In percentages:"..getEnergyPercentage(reactors[index].getEnergyStored()))
  functions.newLine(w)
  w.write("Fuel temperature: "..reactors[index].getFuelTemperature().." degrees C")
  functions.newLine(w)
  w.write("Casing temperature: "..reactors[index].getCasingTemperature().." degrees C")
  functions.newLine(w)
  w.write("Fuel: "..reactors[index].getFuelAmount().." mB")
  functions.newLine(w)
  w.write("Waste: "..reactors[index].getWasteAmount().." mB")
  functions.newLine(w)
  w.write("RF/tick "..reactors[index].getEnergyProducedLastTick().." RF")
  functions.newLine(w)
  --Interesting part

end

-- BUTTON CLICK HANDLERS
function exitButtonClick()
  m.clear()
  shutDownAllReactors()
 os.exit(0)
end

function switchButtonClick()
  currentlyDisplaying = currentlyDisplaying + 1
  if currentlyDisplaying > numberOfReactors then
    currentlyDisplaying = 1
  end
  print("display index number: "..currentlyDisplaying)
  drawTextPart(textField)
end

function viewHistoryButtonClick()
  infoField.setCursorPos(1,1)
  infoField.clear()
  infoField.write("Pressed vh button")
end
--END BUTTON CLICK HANDLERS



function touchEvent(xPos, yPos)
  local enummy = 0
  local bool = false
  bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  if bool then enummy = 1 bool = false end
  bool = functions.checkInRangeWindow(viewHistoryButton, xPos, yPos)
  if bool then enummy = 2 bool = false end
  bool = functions.checkInRangeWindow(exitButton, xPos, yPos)
  if bool then enummy = 3 bool = false end

  if enummy == 1 then
    switchButtonClick()
  elseif enummy == 2 then
    viewHistoryButtonClick()
  elseif enummy == 3 then
    exitButtonClick()
  end
end


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



-- ####### Functions for the reactors
function handleReactor(reactor, index)
  local active = reactor.getActive()
  local energy = reactor.getEnergyStored()

  if active then
    if energy > energyTreshold then
      reactor.setActive(false)
      reactorOnline[index] = false
      print("Stopped reactor "..index)
    end
  else
    if energy < energyTreshold then
      reactor.setActive(true)
      reactorOnline[index] = true
      print("Started reactor "..index)
    end
  end
end

function checkAllReactorsOffline()
  for i = 1, #reactorNumbers, 1 do
    if reactorOnline[i] == true then
      return false
    end
  end
  return true
end

function shutDownAllReactors()
  for i = 1, numberOfReactors, 1 do
    reactors[i].setActive(false)
  end
  print("Shut down all reactors.")
end
--END reactor functions

--Fill static windows
createTopPart(topPart)
drawInfoPart(infoField)
drawTextPart(textField)


local waitLonger = false

--Main loop
while true do

  for i = 1, #reactors, 1 do
    handleReactor(reactors[i], i)
  end
  drawInfoPart(infoField)
  drawTextPart(textField)

  waitLonger = checkAllReactorsOffline()

  if waitLonger then
    wait(sleepTime)
  else
    wait(sleepTime)
  end

end
