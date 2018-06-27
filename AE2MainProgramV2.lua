
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
local inscriberInterface
pulverizerInterface = peripheral.wrap("tileinterface_9")
furnaceInterface = peripheral.wrap("tileinterface_6")
inscriberInterface = peripheral.wrap("tileinterface_10")
furnaceInterface.sideToSendTo = "north"
furnaceInterface.label = "furnace"
pulverizerInterface.label = "pulverizer"
pulverizerInterface.sideToSendTo = "north"
inscriberInterface.sideToSendTo = "north"
inscriberInterface.label = "inscriber"

--Some variables used
local allItemsNetwork --A list of all items in the ME network,
local numberOfItemTypesNetwork -- The number of different items in the network
allItemsNetwork = pulverizerInterface.getAvailableItems(1)

--variables
local currentFingerprint
local currentLabel
local amountOfItemsToSend
local itemList
local interfaceToSendTo

--Creating the main Windows
topPart = window.create(m, 1,1, 50, 4)
returnButton = window.create(m, 51, 1, 11, 4)
topPart.setCursorPos(1, 1)
bottomPart = window.create(m, 1, 5, 61, 36)
bottomPart.setCursorPos(1, 1)

--Creating subwindows
local startWindow = window.create(bottomPart, 1, 1, 61, 36)
startWindow.isActive = true
local pulverizerWindow = window.create(bottomPart, 1, 1, 61, 36)
pulverizerWindow.isActive = false
local furnaceWindow = window.create(bottomPart, 1, 1, 61, 36)
furnaceWindow.isActive = false
local amountWindow = window.create(bottomPart, 1, 1, 61, 36)
amountWindow.isActive = false
local processingWindow = window.create(bottomPart, 1, 1, 61, 36)
processingWindow.isActive = false
local inscriberWindow = window.create(bottomPart, 1, 1, 61, 36)
inscriberWindow.isActive = false

--STartwindow components
local dividedWindows = functions.returnWindows(startWindow, 1, 1, 61, 36, 5, false)
local infoFieldStartWindow = dividedWindows[1]
local windowSwitchPulverizer = dividedWindows[2]
local windowSwitchFurnace = dividedWindows[3]
local windowSwitchCrafting = dividedWindows[4]
local windowSwitchInscriber = dividedWindows[5]

function windowSwitchPulverizer.onClick()
  interfaceToSendTo = pulverizerInterface
  toggleWindows(pulverizerWindow)
end
function windowSwitchFurnace.onClick()
  interfaceToSendTo = furnaceInterface
  toggleWindows(furnaceWindow)
end
function windowSwitchCrafting.onClick()
end
function windowSwitchInscriber.onClick()
  interfaceToSendTo = inscriberInterface
  toggleWindows(inscriberWindow)
end



--Needed for keyhandling
function setExtraWindowKeys(object,fp, label)
  local returnedObject = object
  returnedObject.fingerprint = fp
  returnedObject.label = label
  return returnedObject
end

local inscriberGrid = functions.returnWindowGrid({m=inscriberWindow, x=1, y=1, width=61,height=36, offsetY=4, partshorizontal=4, partsvertical=5})
inscriberGrid[1][1] = setExtraWindowKeys(inscriberGrid[1][1], fingerprints..goldingot, "gold")
inscriberGrid[1][2] = setExtraWindowKeys(inscriberGrid[1][2], fingerprints.diamond, "diamond")
inscriberGrid[1][3] = setExtraWindowKeys(inscriberGrid[1][3], fingerprints.silicon, "silicon")
inscriberGrid[1][4] = setExtraWindowKeys(inscriberGrid[1][4], fingerprints.purecertusquartz, "pure certus")

function inscriberWindow.onClick(gridItem)
  interfaceToSendTo = inscriberInterface
  currentFingerprint = gridItem.fingerprint
  currentLabel = gridItem.label
  toggleWindows(amountWindow)
end

--Furnacewindow components: 5x4 rows
local furnaceGrid = functions.returnWindowGrid({m=furnaceWindow, x=1, y=1, width=61,height=36, offsetY=4, partshorizontal=4, partsvertical=5})

furnaceGrid[1][1] = setExtraWindowKeys(furnaceGrid[1][1], fingerprints.pulverizedgold, "pul.gold")
furnaceGrid[1][2] = setExtraWindowKeys(furnaceGrid[1][2], fingerprints.pulverizediron, "pul.iron")
furnaceGrid[2][1] = setExtraWindowKeys(furnaceGrid[2][1], fingerprints.sand, "sand")
furnaceGrid[2][2] = setExtraWindowKeys(furnaceGrid[2][2], fingerprints.cobble, "cobble")
furnaceGrid[2][3] = setExtraWindowKeys(furnaceGrid[2][3], fingerprints.sprucewood, "sprucewood")

function furnaceWindow.onClick(gridItem)
  interfaceToSendTo = furnaceInterface
  currentFingerprint = gridItem.fingerprint
  currentLabel = gridItem.label
  toggleWindows(amountWindow)
end

--Pulverizer window components, same as above
local pulverizerGrid = functions.returnWindowGrid({m=pulverizerWindow, x=1, y=1, width=61,height=36, offsetY=4, partshorizontal=4, partsvertical=5})
pulverizerGrid[1][1] = setExtraWindowKeys(pulverizerGrid[1][1], fingerprints.cobble, "cobble")
pulverizerGrid[1][2] = setExtraWindowKeys(pulverizerGrid[1][2], fingerprints.sand, "sand")

function pulverizerWindow.onClick(gridItem)
  interfaceToSendTo = pulverizerInterface
  currentFingerprint = gridItem.fingerprint
  currentLabel = gridItem.label
  toggleWindows(amountWindow)
end

--Amountwindow components: 5x5 rows
local amountGrid = functions.returnWindowGrid({m=amountWindow, x=1, y=1, width=61,height=36, offsetY=4, partshorizontal=4, partsvertical=5})
local tempX, tempY = functions.sizeMatrix(amountGrid)

local tempNumber = 0
for i = 1, tempX, 1 do
      tempNumber = (tempNumber + 1) * i
  for j = 1, tempY, 1 do
    amountGrid[i][j].value = j *tempNumber * 64
    amountGrid[i][j].label = tostring(j * tempNumber).." x 64"
  end
end
amountGrid[tempX][tempY].value = 108 * 64
amountGrid[tempX][tempY].label = tostring(108).." x 64"

print(amountGrid[2][2].label)



function amountWindow.onClick(gridItem)
  amountOfItemsToSend = gridItem.value
  fillChest(interfaceToSendTo, chestSizes.obsidian, currentFingerprint, amountOfItemsToSend)
end
-- I'm not gonna name them all

--Processingwindow componenents
local dividedWindows11 = functions.returnWindows(processingWindow, 1, 1, 61, 36, 3, false)
local infoFieldProcessingWindow = dividedWindows11[1]
local changingFieldProcessingWindow = dividedWindows11[2]
local successFieldProcessingWindow = dividedWindows11[3]


function setProcessingStatus(status)
  successFieldProcessingWindow.clear()
  successFieldProcessingWindow.setCursorPos(1,1)
  if status == "processing" then
    successFieldProcessingWindow.setBackgroundColor(128)
    successFieldProcessingWindow.setTextColor(1)
    functions.textInMiddleButton(successFieldProcessingWindow,"Job in progress.")
    functions.newLine(successFieldProcessingWindow)
    if interfaceToSendTo == pulverizerInterface then
      functions.textInMiddleButton(successFieldProcessingWindow,"Sending to pulverizer chest...")
    elseif interfaceToSendTo == furnaceInterface then
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



--Function to send items to somewhere
--###########Specific functions that have to be here cause of sleep############
--Fills the whole chest with items
function fillChest(interface, sizeChest, fingerprint, amount)
  regetItems(interface)
  toggleWindows(processingWindow)
  setProcessingStatus("processing")
  side = interface.sideToSendTo
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
    toggleWindows(startWindow)
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
  functions.textInMiddleButton(infoFieldProcessingWindow, "Currently processing "..currentLabel.." to "..interfaceToSendTo.label)
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
      toggleWindows(startWindow)
      return
    end

  end

  setProcessingStatus("done")
  sleep(5)
  toggleWindows(startWindow)
end

function toggleColor(col)
  if col == 4096 then return 128 end
  if col == 128 then return 32768 end
  if col == 32768 then return 4096 end
end


function createAmountWindowComponents()
  local currentColor
  currentColor = 4096

  local M, N = functions.sizeMatrix(amountGrid)
  print("in createAmountWindow")
  for i = 1, M, 1 do
    for j = 1, N, 1 do
    amountGrid[i][j].setTextColor(1)
    amountGrid[i][j].setBackgroundColor(currentColor)
    amountGrid[i][j].clear()
    functions.textInMiddleButton(amountGrid[i][j], amountGrid[i][j].label)
    currentColor = toggleColor(currentColor)
  end
  end
end

V2Layout.createTopPart(topPart)
V2Layout.createInfoFieldStartWindow(infoFieldStartWindow)
V2Layout.createWindowSwitchFurnace(windowSwitchFurnace)
V2Layout.createWindowSwitchPulverizer(windowSwitchPulverizer)
V2Layout.createReturnButton(returnButton)
V2Layout.createLabeledButtons(furnaceGrid)
V2Layout.createLabeledButtons(pulverizerGrid)
V2Layout.createLabeledButtons(amountGrid)
V2Layout.createWindowSwitchInscriber(inscriberGrid)
V2Layout.createProcessingWindowComponents(infoFieldProcessingWindow, changingFieldProcessingWindow, successFieldProcessingWindow)


pulverizerWindow.subwindows = pulverizerGrid
pulverizerWindow.typeSubwindows = "grid"

furnaceWindow.subwindows = furnaceGrid
furnaceWindow.typeSubwindows = "grid"

inscriberWindow.subwindows = inscriberGrid
inscriberWindow.typeSubwindows = "grid"

amountWindow.subwindows = amountGrid
amountWindow.typeSubwindows = "grid"
--List of all the main windows to switch between

startWindow.subwindows = {infoFieldStartWindow, windowSwitchPulverizer, windowSwitchFurnace, windowSwitchCrafting, windowSwitchInscriber}
startWindow.typeSubwindows = "custom"

local mainWindowList = {startWindow, pulverizerWindow, furnaceWindow, inscriberWindow, amountWindow, processingWindow}

function toggleWindows(win)
  for i = 1, #mainWindowList, 1 do
    mainWindowList[i].isActive = false
    mainWindowList[i].setVisible(false)
  end
  win.isActive = true
  win.setVisible(true)
end

toggleWindows(startWindow)


--Gets a list of all items in system
function regetItems(interf)
  allItemsNetwork = interf.getAvailableItems(1)
  numberOfItemTypesNetwork = #allItemsNetwork
end

regetItems(furnaceInterface)

--Button click handlers
function clickedReturnButton()
  if startWindow.isActive then
    m.clear()
    print("shutting down program")
   os.exit(0)
 elseif (pulverizerWindow.isActive) or (furnaceWindow.isActive) then
    toggleWindows(startWindow)
  elseif amountWindow.isActive then
    if interfaceToSendTo == furnaceInterface then
      toggleWindows(furnaceWindow)
    elseif interfaceToSendTo == pulverizerInterface then
      toggleWindows(pulverizerWindow)
    elseif interfaceToSendTo == inscriberInterface then
      toggleWindows(inscriberWindow)
    end
  end
end

--Timer functions
function processEvents(event)
  if event[1] == "monitor_touch" then
    bool = functions.checkInRangeWindow(returnButton, event[3], event[4])
    if bool then clickedReturnButton() return end

    local activeWindow
    for i = 1, #mainWindowList, 1 do
      if mainWindowList[i].isActive then activeWindow = mainWindowList[i] break end
    end

    local xPos = event[3]
    local yPos = event[4] - 4

    if activeWindow.typeSubwindows == "custom" then
      for i = 1, #activeWindow.subwindows, 1 do
        bool = functions.checkInRangeWindow(activeWindow.subwindows[i], xPos, yPos)
        if bool and (activeWindow.subwindows[i].onClick ~= nil) then
          activeWindow.subwindows[i].onClick()
          break
        end
      end
    elseif activeWindow.typeSubwindows == "grid" then
      local M, N = functions.sizeMatrix(activeWindow.subwindows)
      for i = 1, M, 1 do
        for j = 1, N, 1 do
          bool = functions.checkInRangeWindow(activeWindow.subwindows[i][j], xPos, yPos)
          if bool and (activeWindow.onClick ~= nil) then
            activeWindow.onClick(activeWindow.subwindows[i][j])
            break
          end
        end
      end
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
  wait(0.5)
end
