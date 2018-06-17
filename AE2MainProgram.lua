



--Main program for AE2 stuff
--Some constants
local chestSizes = {}
chestSizes["obsidian"] = 108
chestSizes["woodSingle"] = 27

--Add needed functions
os.loadAPI("/git/scripts/functions")
os.loadAPI('/git/scripts/MEfunctions')
os.loadAPI('/git/data/fingerprints')

--Monitors stuff
local m
m = peripheral.wrap("left")
m.clear()

--variables
local currentActiveWindow = "start"

--Creating the main Windows
topPart = window.create(m, 1,1, 50, 4)
returnButton = window.create(m, 51, 1, 11, 4)
topPart.setCursorPos(1, 1)
bottomPart = window.create(m, 1, 5, 61, 36)
bottomPart.setCursorPos(1, 1)

--Creating subwindows
local startWindow = window.create(bottomPart, 1, 1, 61, 36)
local pulverizerWindow = window.create(bottomPart, 1, 1, 61, 36)
local furnaceWindow = window.create(bottomPart, 1, 1, 61, 36)
local processingWindow = window.create(bottomPart, 1, 1, 61, 36)

--STartwindow components
local dividedWindows = functions.returnWindows(startWindow, 1, 1, 61, 36, 4, false)
local infoFieldStartWindow = dividedWindows[1]
local windowSwitchPulverizer = dividedWindows[2]
local windowSwitchFurnace = dividedWindows[3]
local windowSwitchCrafting = dividedWindows[4]
local xxx, yyy = infoFieldStartWindow.getPosition()
print("x="..xxx.."y="..yyy)

function toggleWindows(win)
  pulverizerWindow.setVisible(false)
  furnaceWindow.setVisible(false)
  processingWindow.setVisible(false)
  startWindow.setVisible(false)
  if win == "pul" then
    pulverizerWindow.setVisible(true)
  elseif win == "fur" then
    furnaceWindow.setVisible(true)
  elseif win == "start" then
    startWindow.setVisible(true)
  elseif win == "processing" then
    processingWindow.setVisible(true)
  end
  currentActiveWindow = win
end

--Set startwindow as active one
toggleWindows("start")

functions.fillWindow(startWindow, 64)
functions.fillWindow(pulverizerWindow, 16384)
functions.fillWindow(furnaceWindow, 128)
functions.fillWindow(windowSwitchFurnace, 64) -- pink
functions.fillWindow(windowSwitchPulverizer, 1)
functions.fillWindow(windowSwitchCrafting, 2)
functions.fillWindow(infoFieldStartWindow, 16)


-- Drawing functions for all windows
function createReturnButton()
  returnButton.setBackgroundColor(128)
  returnButton.setTextColor(1)
  functions.fillButton(returnButton, "Return")
end

function createInfoFieldStartWindow()
  infoFieldStartWindow.clear()
  infoFieldStartWindow.setCursorPos(1,1)
  infoFieldStartWindow.write("Welcome! What do you want to do?")
  functions.newLine(infoFieldStartWindow)
  infoFieldStartWindow.write("Choose one of the options from below.")
end

function createWindowSwitchFurnace()
  windowSwitchFurnace.clear()
  windowSwitchFurnace.setCursorPos(1,1)
  windowSwitchFurnace.write("Send stuff to furnace")
  functions.newLine(windowSwitchFurnace)
end

function createWindowSwitchPulverizer()
  windowSwitchPulverizer.clear()
  windowSwitchPulverizer.setCursorPos(1,1)
  windowSwitchPulverizer.write("Send stuff to pulverizer")
  functions.newLine(windowSwitchPulverizer)
end



function createTopPart(w)
  w.setBackgroundColor(16384) --Red
  w.setTextColor(32768) --Black
  w.write("****************************************************************")
  functions.newLine(w)
  w.write("***********  AE2 functions program  ********************************")
  functions.newLine(w)
  w.write("****************************************************************")
  functions.newLine(w)
  w.setTextColor(64) --Pink
  w.setBackgroundColor(32768) --Black
  w.write("Written by Merlione404")
end

print("psadasdasdp")
createTopPart(topPart)
createInfoFieldStartWindow()
createWindowSwitchFurnace()
createWindowSwitchPulverizer()
createReturnButton()
--BUTTON HANDLE FUNCTIONS
--TODO



--Get the interfaces that are used from the network
local pulverizerInterface
local furnaceInterface
pulverizerInterface = peripheral.wrap("tileinterface_7")
furnaceInterface = peripheral.wrap("tileinterface_6")

--Some variables used
local allItemsNetwork --A list of all items in the ME network,
local numberOfItemTypesNetwork -- The number of different items in the network
allItemsNetwork = pulverizerInterface.getAvailableItems(1)

--Gets a list of all items in system
function regetItems(interf)
  allItemsNetwork = interf.getAvailableItems(1)
  numberOfItemTypesNetwork = #allItemsNetwork
end

regetItems(furnaceInterface)

--Handles all touch events
function touchEvent(xPos, yPos)
  local enummy = 0
  local bool = false
  --bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  --if bool then enummy = 1 bool = false end
  print(xPos..","..yPos)
  tempBool = checkInRangeWindow(windowSwitchFurnace,xPos,yPos)
  print(tempBool)

  if enummy == 1 then
    --function
  elseif enummy == 2 then

  elseif enummy == 3 then
  end
end


--Timer functions
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


--Specific functions that have to be here cause of sleep
--Fills the whole chest with items
function fillChest(interface, side, sizeChest, fingerprint, amount)
  local itemsToBeTransported
  itemsToBeTransported = amount
  local canExportToSide
  canExportToSide = interface.canExport(side)

  if canExportToSide == false then
    print("Couldn't export to side "..side.." item "..fingerprint.id)
    return
  end
  local counter1
  counter1 = 1
  local returnedTable
  local notDoneTransporting
  notDoneTransporting = true

  while notDoneTransporting do
    local returnedTable
    returnedTable = interface.exportItem(fingerprint, side, itemsToBeTransported, counter1)

    if (returnedTable ~= nil) and (returnedTable["size"] ~= nil) then
      itemsToBeTransported = itemsToBeTransported - tonumber(returnedTable["size"])
    end

    counter1 = counter1 + 1

    if counter1 > sizeChest then counter1 = 1 end
    if itemsToBeTransported == 0 then notDoneTransporting = false end
    wait(3)
  end
end

fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizedgold, 300)
fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizedsilver, 300)
