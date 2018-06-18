
print("adasasddsa")


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
local amountOf

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
local amountWindow = window.create(bottomPart, 1, 1, 61, 36)
local processingWindow = window.create(bottomPart, 1, 1, 61, 36)

--STartwindow components
local dividedWindows = functions.returnWindows(startWindow, 1, 1, 61, 36, 4, false)
local infoFieldStartWindow = dividedWindows[1]
local windowSwitchPulverizer = dividedWindows[2]
local windowSwitchFurnace = dividedWindows[3]
local windowSwitchCrafting = dividedWindows[4]
local xxx, yyy = infoFieldStartWindow.getPosition()

--Furnacewindow components: 5x5 rows
local dividedWindows1 = functions.returnWindows(furnaceWindow, 1, 1, 61, 7, 5, true)
local dividedWindows2 = functions.returnWindows(furnaceWindow, 1, 8, 61, 7, 5, true)
local dividedWindows3 = functions.returnWindows(furnaceWindow, 1, 15, 61, 7, 5, true)
local dividedWindows4 = functions.returnWindows(furnaceWindow, 1, 22, 61, 7, 5, true)
local dividedWindows5 = functions.returnWindows(furnaceWindow, 1, 29, 61, 8, 5, true)

--Amountwindow components: 5x5 rows

local goldButton1 = dividedWindows1[1]
local ironButton1 = dividedWindows1[2]

function toggleWindows(win)
  pulverizerWindow.setVisible(false)
  furnaceWindow.setVisible(false)
  processingWindow.setVisible(false)
  startWindow.setVisible(false)
  amountWindow.setVisible(false)
  if win == "pul" then
    pulverizerWindow.setVisible(true)
    amountOf = "pul"
  elseif win == "fur" then
    furnaceWindow.setVisible(true)
    amountOf = "fur"
  elseif win == "start" then
    startWindow.setVisible(true)
  elseif win == "amount" then
    processingWindow.setVisible(true)
  elseif win == "processing" then
    processingWindow.setVisible(true)
  end
  currentActiveWindow = win
end



--Set startwindow as active one
toggleWindows("start")

functions.fillWindow(startWindow, 64)
functions.fillWindow(pulverizerWindow, 16384)
functions.fillWindow(windowSwitchFurnace, 64) -- pink
functions.fillWindow(windowSwitchPulverizer, 1)
functions.fillWindow(windowSwitchCrafting, 2)
functions.fillWindow(infoFieldStartWindow, 16)


-- Drawing functions for all windows
function createFurnaceButtons()
  goldButton1.setBackgroundColor(128)
  goldButton1.setTextColor(1)
  functions.fillButton(goldButton1, "pulv. gold")

  ironButton1.setBackgroundColor(128)
  ironButton1.setTextColor(1)
  functions.fillButton(ironButton1, "pulv. iron")
end

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


createTopPart(topPart)
createInfoFieldStartWindow()
createWindowSwitchFurnace()
createWindowSwitchPulverizer()
createReturnButton()
createFurnaceButtons()
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

--Button click handlers
function clickedReturnButton()
  if currentActiveWindow == "start" then
    m.clear()
    print("shutting down program")
   os.exit(0)
  elseif (currentActiveWindow == "pul") or (currentActiveWindow == "fur") then
    toggleWindows("start")
  end
end

function clickedWindowSwitchPulverizerButton()
  toggleWindows("pul")
end

function clickedWindowSwitchFurnaceButton()
  toggleWindows("fur")
end




--Handles all touch events
function touchEventStartWindow(xPos, yPos)
  local enummy = 0
  local bool = false
  --bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  --if bool then enummy = 1 bool = false end
  print(xPos..","..yPos)

  --Buttons located at normal x,y


  --Buttons that are transposed
  yPos = yPos - 4
  bool = functions.checkInRangeWindow(windowSwitchFurnace, xPos, yPos)
  if bool then print("in range furnace") enummy = 1 bool = false end
  bool = functions.checkInRangeWindow(windowSwitchPulverizer, xPos, yPos)
  if bool then print("in range pul") enummy = 2 bool = false end
  bool = functions.checkInRangeWindow(windowSwitchCrafting, xPos, yPos)
  if bool then print("in range craf") enummy = 3 bool = false end

  if enummy == 1 then
    clickedWindowSwitchPulverizerButton()
  elseif enummy == 2 then
    clickedWindowSwitchFurnaceButton()
  elseif enummy == 3 then

  elseif enummy == 4 then
    clickedReturnButton()
  end
end


--Timer functions
function processEvents(event)
  if event[1] == "monitor_touch" then
    bool = functions.checkInRangeWindow(returnButton, event[3], event[4])
    if bool then clickedReturnButton() return end

    if currentActiveWindow == "start" then
      touchEventStartWindow(event[3], event[4])
    end
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


--###########Specific functions that have to be here cause of sleep############
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

fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizediron, 300)
fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizedsilver, 300)
