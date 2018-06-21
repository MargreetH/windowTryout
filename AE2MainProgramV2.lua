--comment
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
os.loadAPI('/git/V2Layout')

--Monitors stuff
local m
m = peripheral.wrap("left")
m.clear()

--Get the interfaces that are used from the network
local pulverizerInterface
local furnaceInterface
pulverizerInterface = peripheral.wrap("tileinterface_7")
furnaceInterface = peripheral.wrap("tileinterface_6")

--Some variables used
local allItemsNetwork --A list of all items in the ME network,
local numberOfItemTypesNetwork -- The number of different items in the network
allItemsNetwork = pulverizerInterface.getAvailableItems(1)

--variables
local currentActiveWindow = "start"
local amountOf
local currentFingerprint
local amountOfItemsToSend
local itemList

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

--Needed for keyhandling
function setExtraWindowKeys(object,fp, amo, label)
  local returnedObject = object
  returnedObject.fingerprint = fp
  returnedObject.amountOf = amo
  returnedObject.label = label
  return returnedObject
end

--Furnacewindow components: 5x4 rows
local furnaceGrid = functions.returnWindowGrid({m=furnaceWindow, x=1, y=1, width=61,height=36, offsetY=4, partshorizontal=4, partsvertical=5})

furnaceGrid[1][1] = setExtraWindowKeys(furnaceGrid[1][1], fingerprints.pulverizedgold, "fur", "pul.gold")
furnaceGrid[1][2] = setExtraWindowKeys(furnaceGrid[1][2], fingerprints.pulverizediron, "fur", "pul.iron")
furnaceGrid[2][1] = setExtraWindowKeys(furnaceGrid[2][1], fingerprints.sand, "fur", "sand")
furnaceGrid[2][2] = setExtraWindowKeys(furnaceGrid[2][2], fingerprints.cobble, "fur", "cobble")
furnaceGrid[2][3] = setExtraWindowKeys(furnaceGrid[2][3], fingerprints.sprucewood, "fur", "sprucewood")

--Pulverizer window components, same as above
local pulverizerGrid = functions.returnWindowGrid({m=pulverizerWindow, x=1, y=1, width=61,height=7, offsetY=4, partshorizontal=4, partsvertical=5})
pulverizerGrid[1][1] = setExtraWindowKeys(pulverizerGrid[1][1], fingerprints.cobble, "pul", "cobble")
pulverizerGrid[1][2] = setExtraWindowKeys(pulverizerGrid[1][2], fingerprints.sand, "pul", "sand")

--Amountwindow components: 5x5 rows
local dividedWindows6 = functions.returnWindows(amountWindow, 1, 1, 61, 7, 4, true)
local dividedWindows7 = functions.returnWindows(amountWindow, 1, 8, 61, 7, 4, true)
local dividedWindows8 = functions.returnWindows(amountWindow, 1, 15, 61, 7, 4, true)
local dividedWindows9 = functions.returnWindows(amountWindow, 1, 22, 61, 7, 4, true)
local dividedWindows10 = functions.returnWindows(amountWindow, 1, 29, 61, 8, 4, true)
-- I'm not gonna name them all

--Processingwindow componenents
local dividedWindows11 = functions.returnWindows(processingWindow, 1, 1, 61, 36, 3, false)
local infoFieldProcessingWindow = dividedWindows11[1]
local changingFieldProcessingWindow = dividedWindows11[2]
local successFieldProcessingWindow = dividedWindows11[3]

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
    amountWindow.setVisible(true)
  elseif win == "processing" then
    processingWindow.setVisible(true)
  end
  currentActiveWindow = win
end



--Set startwindow as active one
toggleWindows("start")

functions.fillWindow(windowSwitchPulverizer, 1)

function setProcessingStatus(status)
  successFieldProcessingWindow.clear()
  successFieldProcessingWindow.setCursorPos(1,1)
  if status == "processing" then
    successFieldProcessingWindow.setBackgroundColor(128)
    successFieldProcessingWindow.setTextColor(1)
    functions.textInMiddleButton(successFieldProcessingWindow,"Job in progress.")
    functions.newLine(successFieldProcessingWindow)
    if amountOf == "pul" then
      functions.textInMiddleButton(successFieldProcessingWindow,"Sending to pulverizer chest...")
    elseif amountOf == "fur" then
      functions.textInMiddleButton(successFieldProcessingWindow,"Sending to furnace chest...")
    end
  elseif status == "done" then
    successFieldProcessingWindow.setBackgroundColor(32)
    successFieldProcessingWindow.setTextColor(32768	)
    functions.textInMiddleButton(successFieldProcessingWindow,"Job completed succesfully")
  elseif status == "failed" then
    successFieldProcessingWindow.setBackgroundColor(16384)
    successFieldProcessingWindow.setTextColor(32768	)
    functions.textInMiddleButton(successFieldProcessingWindow,"Job completed without transporting all items")
  end
end

function rewriteChangingField(currentlytransported, totalamount)
functions.textInMiddleButton(changingFieldProcessingWindow, "Transported "..currentlytransported.." of "..totalamount)

end

-- Drawing functions for all windows
function createProcessingWindowComponents()
 infoFieldProcessingWindow.setCursorPos(1,1)
 infoFieldProcessingWindow.setBackgroundColor(4096)
 infoFieldProcessingWindow.setTextColor(1)
 functions.textInMiddleButton(infoFieldProcessingWindow, "Currently processing resources.")

 changingFieldProcessingWindow.setCursorPos(1,1)
 changingFieldProcessingWindow.setBackgroundColor(128)
 changingFieldProcessingWindow.setTextColor(1)

 successFieldProcessingWindow.setCursorPos(1,1)
 successFieldProcessingWindow.setBackgroundColor(2048)
 successFieldProcessingWindow.setTextColor(1)
 functions.textInMiddleButton(successFieldProcessingWindow, "Job in progress.")
end

--Function to send items to somewhere
--###########Specific functions that have to be here cause of sleep############
--Fills the whole chest with items
function fillChest(interface, side, sizeChest, fingerprint, amount)
  regetItems(interface)
  toggleWindows("processing")
  setProcessingStatus("processing")
  local itemsToBeTransported
  itemsToBeTransported = amount
  local canExportToSide
  canExportToSide = interface.canExport(side)

  -- Check if there is actually a chest!
  if canExportToSide == false then
    print("Couldn't export to side "..side.." item "..fingerprint.id)
    setProcessingStatus("failed")
    return
  end

  --Check if there is actually enough items in the system
  local amountStored
  amountStored = MEfunctions.returnAmountOfItemsInSystem(fingerprint, allItemsNetwork)

  if amountStored == 0 or amountStored == nil then
    setProcessingStatus("failed")
    functions.textInMiddleButton(infoFieldProcessingWindow, "No items of this type are stored in the system!")
    sleep(5)
    toggleWindows("start")
    return
  elseif amountStored < amount then
  infoFieldProcessingWindow.clear()
  infoFieldProcessingWindow.setCursorPos(1,1)
  functions.textInMiddleButton(infoFieldProcessingWindow, "Only "..amountStored.." of "..amount.." requested items are present. Transporting those.")
  itemsToBeTransported = amountStored
  else
  infoFieldProcessingWindow.clear()
  infoFieldProcessingWindow.setCursorPos(1,1)
  infoFieldProcessingWindow.setBackgroundColor(4096)
  infoFieldProcessingWindow.setTextColor(1)
  functions.textInMiddleButton(infoFieldProcessingWindow, "Currently processing resources.")
  end

  local counter1
  local counter2 = 1
  counter1 = 1
  local returnedTable
  local notDoneTransporting
  notDoneTransporting = true
  local transportedSoFar = 0

  while notDoneTransporting do
    counter2 = counter2 + 1
    local returnedTable
    returnedTable = interface.exportItem(fingerprint, side, itemsToBeTransported, counter1)

    if (returnedTable ~= nil) and (returnedTable["size"] ~= nil) then
      itemsToBeTransported = itemsToBeTransported - tonumber(returnedTable["size"])
      transportedSoFar = transportedSoFar + tonumber(returnedTable["size"])
    end

    counter1 = counter1 + 1

    rewriteChangingField(transportedSoFar, amount)

    if counter1 > sizeChest then counter1 = 1 end
    if itemsToBeTransported == 0 then notDoneTransporting = false end
    if counter2 > 500 then --Chest is fulll and not being emptied, abort the exporting.
      setProcessingStatus("failed")
      sleep(5)
      toggleWindows("start")
      return
    end

  end

  setProcessingStatus("done")
  sleep(5)
  toggleWindows("start")
end

function toggleColor(col)
  if col == 4096 then return 128 end
  if col == 128 then return 32768 end
  if col == 32768 then return 4096 end
end


function createAmountWindowComponents()
  local currentColor
  currentColor = 4096

  for i = 1, 4, 1 do
    dividedWindows6[i].setBackgroundColor(currentColor)
    functions.textInMiddleButton(dividedWindows6[i], tostring(i).."x 64")
    currentColor = toggleColor(currentColor)
    dividedWindows7[i].setBackgroundColor(currentColor)
    functions.textInMiddleButton(dividedWindows7[i], tostring(i*2).."x 64")
    currentColor = toggleColor(currentColor)
    dividedWindows8[i].setBackgroundColor(currentColor)
    functions.textInMiddleButton(dividedWindows8[i], tostring(i*4).."x 64")
    currentColor = toggleColor(currentColor)
    dividedWindows9[i].setBackgroundColor(currentColor)
    functions.textInMiddleButton(dividedWindows9[i], tostring(i*16).."x 64")
    currentColor = toggleColor(currentColor)
    dividedWindows10[i].setBackgroundColor(currentColor)
    functions.textInMiddleButton(dividedWindows10[i], tostring(i*27).."x 64")
    currentColor = toggleColor(currentColor)
  end
end

function createPulverizerButtons()
  local currentColor = 4096
    for j = 1, #pulverizerGrid[1], 1 do
      for i = 1, #pulverizerGrid, 1 do

        pulverizerGrid[i][j].setTextColor(1)
        pulverizerGrid[i][j].setBackgroundColor(currentColor)
        currentColor = toggleColor(currentColor)

        if pulverizerGrid[i][j].label ~= nil then
          functions.textInMiddleButton(pulverizerGrid[i][j], pulverizerGrid[i][j].label)
        end
      end
    end
end

function createFurnaceButtons()

local currentColor = 4096
  for j = 1, #furnaceGrid[1], 1 do
    for i = 1, #furnaceGrid, 1 do

      furnaceGrid[i][j].setTextColor(1)
      furnaceGrid[i][j].setBackgroundColor(currentColor)
      currentColor = toggleColor(currentColor)

      if furnaceGrid[i][j].label ~= nil then
        functions.textInMiddleButton(furnaceGrid[i][j], furnaceGrid[i][j].label)
      end
    end
  end
end

function createReturnButton()
  returnButton.setBackgroundColor(128)
  returnButton.setTextColor(1)
  functions.textInMiddleButton(returnButton, "Return")
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
  functions.textInMiddleButton(windowSwitchFurnace,"Send stuff to furnace")
  functions.newLine(windowSwitchFurnace)
end

function createWindowSwitchPulverizer()
  windowSwitchPulverizer.clear()
  windowSwitchPulverizer.setCursorPos(1,1)
  functions.textInMiddleButton(windowSwitchPulverizer,"Send stuff to pulverizer")
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
createAmountWindowComponents()
createProcessingWindowComponents()
createPulverizerButtons()
--BUTTON HANDLE FUNCTIONS
--TODO

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
  elseif currentActiveWindow == "amount" then
    toggleWindows(amountOf)
  end
end

function clickedWindowSwitchPulverizerButton()
  toggleWindows("pul")
end

function clickedWindowSwitchFurnaceButton()
  toggleWindows("fur")
end

--Handles all touch events
function touchEventAmountWindow(xPos, yPos)
  local enummy = 0
  local bool = false
  --bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  --if bool then enummy = 1 bool = false end


  --Buttons located at normal x,y
  --Buttons that are transposed
  yPos = yPos - 4

  for i = 1, 5, 1 do
    bool = functions.checkInRangeWindow(dividedWindows6[i], xPos, yPos)
    if bool then amountOfItemsToSend = i * 64 break end
    bool = functions.checkInRangeWindow(dividedWindows7[i], xPos, yPos)
    if bool then amountOfItemsToSend = i*2 * 64 break end
    bool = functions.checkInRangeWindow(dividedWindows8[i], xPos, yPos)
    if bool then amountOfItemsToSend = i*4 * 64 break end
    bool = functions.checkInRangeWindow(dividedWindows9[i], xPos, yPos)
    if bool then amountOfItemsToSend = i*16 * 64 break end
    bool = functions.checkInRangeWindow(dividedWindows10[i], xPos, yPos)
    if bool then amountOfItemsToSend = i*27 * 64 break end
  end
if amountOf == "pul" then
  fillChest(pulverizerInterface, "west", chestSizes.obsidian, currentFingerprint, amountOfItemsToSend)
elseif amountOf == "fur" then
  fillChest(furnaceInterface, "north", chestSizes.obsidian, currentFingerprint, amountOfItemsToSend)
end
end

function touchEventPulverizerWindow(xPos, yPos)
  local bool = false
  --bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  --if bool then enummy = 1 bool = false end
  --Buttons located at normal x,y
  --Buttons that are transposed
  yPos = yPos - 4

  for j = 1, #pulverizerGrid[1], 1 do
    for i = 1, #pulverizerGrid, 1 do

      bool = functions.checkInRangeWindow(pulverizerGrid[i][j], xPos, yPos)

      if (pulverizerGrid[i][j].fingerprint ~= nil) and bool then
        amountOf = pulverizerGrid[i][j].amountOf
        currentFingerprint = pulverizerGrid[i][j].fingerprint
        toggleWindows("amount")
        return
      end
    end
  end
end



function touchEventFurnaceWindow(xPos, yPos)

  local bool = false
  --bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  --if bool then enummy = 1 bool = false end
  --Buttons located at normal x,y
  --Buttons that are transposed
  yPos = yPos - 4

  for j = 1, #furnaceGrid[1], 1 do
    for i = 1, #furnaceGrid, 1 do

      bool = functions.checkInRangeWindow(furnaceGrid[i][j], xPos, yPos)

      if (furnaceGrid[i][j].fingerprint ~= nil) and bool then
        amountOf = furnaceGrid[i][j].amountOf
        currentFingerprint = furnaceGrid[i][j].fingerprint
        toggleWindows("amount")
        return
      end
    end
  end
end


--Handles all touch events
function touchEventStartWindow(xPos, yPos)
  local enummy = 0
  local bool = false
  --bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  --if bool then enummy = 1 bool = false end


  --Buttons located at normal x,y
  --Buttons that are transposed
  yPos = yPos - 4
  bool = functions.checkInRangeWindow(windowSwitchFurnace, xPos, yPos)
  if bool then  enummy = 1 bool = false end
  bool = functions.checkInRangeWindow(windowSwitchPulverizer, xPos, yPos)
  if bool then  enummy = 2 bool = false end
  bool = functions.checkInRangeWindow(windowSwitchCrafting, xPos, yPos)
  if bool then  enummy = 3 bool = false end

  if enummy == 1 then
    clickedWindowSwitchFurnaceButton()
  elseif enummy == 2 then
    clickedWindowSwitchPulverizerButton()
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
    elseif currentActiveWindow == "fur" then
      touchEventFurnaceWindow(event[3], event[4])
    elseif currentActiveWindow == "amount" then
      touchEventAmountWindow(event[3], event[4])
    elseif currentActiveWindow == "pul" then
      touchEventPulverizerWindow(event[3], event[4])
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


while true do
  wait(0.05)
end

--fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizediron, 300)
--fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizedsilver, 300)
