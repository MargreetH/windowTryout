-- ITEM fingerprints
local fingerprints = {}
fingerprints.pulverizedgold = {id= "ThermalFoundation:material", dmg = 1}
fingerprints.pulverizediron = {id= "ThermalFoundation:material", dmg = 0}
fingerprints.pulverizedcopper = {id= "ThermalFoundation:material", dmg = 32}
fingerprints.pulverizedlead = {id= "ThermalFoundation:material", dmg = 35}
fingerprints.pulverizedsilver = {id= "ThermalFoundation:material", dmg = 34}
fingerprints.pulverizedtin = {id= "ThermalFoundation:material", dmg = 33}


--Main program for AE2 stuff
--Some constants
local chestSizes = {}
chestSizes["obsidian"] = 108
chestSizes["woodSingle"] = 27

--Add needed functions
os.loadAPI("/git/scripts/functions")
os.loadAPI('/git/scripts/MEfunctions')

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
local infoFieldStartWindow = window.create(startWindow,1, 1, 61, 5)
local dividedWindows = functions.returnWindows(startWindow, 1, 6, 61, 31, 3, false)
local windowSwitchPulverizer = dividedWindows[1]
local windowSwitchFurnace = dividedWindows[2]
local windowSwitchCrafting = dividedWindows[3]
print(windowSwitchCrafting.getPosition())

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
functions.fillWindow(windowSwitchFurnace, 64)
functions.fillWindow(windowSwitchPulverizer, 1)
functions.fillWindow(windowSwitchCrafting, 2)


-- DRawing functions for all windows
function createReturnButton()
  returnButton.setBackgroundColor(128)
  returnButton.setTextColor(1)
  functions.fillButton(returnButton, "Return")
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
createReturnButton()

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

MEfunctions.fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizedgold, 60)
MEfunctions.fillChest(furnaceInterface, "north", chestSizes.obsidian, fingerprints.pulverizedsilver, 60)
