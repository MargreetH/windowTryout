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

--Creating the main Windows
topPart = window.create(m, 1,1, 50, 4)
returnButton = window.create(m, 51, 1, 11, 4)
topPart.setCursorPos(1, 1)
bottomPart = window.create(m, 1, 5, 61, 36)
bottomPart.setCursorPos(1, 1)

--Creating subwindows
local startWindow = window.create(bottomPart, 1, 5, 61, 36)
local pulverizerWindow = window.create(bottomPart, 1, 5, 61, 36)
local furnaceWindow = window.create(bottomPart, 1, 5, 61, 36)
local rocessingWindow = window.create(bottomPart, 1, 5, 61, 36)

function toggleWindows(win)
  pulverizerWindow.setVisible(false)
  furnaceWindow.setVisible(false)
  processingWindow.setVisible(false)
  startWindow.setVisible(false)

  if win == "pul" then
  elseif win == "fur" then
  elseif win == "main" then
  elseif win == "procesing" then
  end
end

--toggle windows
pulverizerWindow.setVisible(false)
furnaceWindow.setVisible(false)
processingWindow.setVisible(false)

functions.fillWindow(startWindow, 64)
functions.fillWindow(pulverizerWindow, 16384)
functions.fillWindow(furnaceWindow, 64)
functions.fillWindow(returnButton, 8192)




-- DRawing functions for all windows
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

--Get the interfaces that are used from the network
local pulverizerInterface
pulverizerInterface = peripheral.wrap("tileinterface_5")

--Some variables used
local allItemsNetwork --A list of all items in the ME network,
local numberOfItemTypesNetwork -- The number of different items in the network
allItemsNetwork = pulverizerInterface.getAvailableItems(1)

--Gets a list of all items in system
function regetItems(interf)
  allItemsNetwork = interf.getAvailableItems(1)
  --numberOfItemTypesNetwork = #allItemsNetwork
end

--regetItems(pulverizerInterface)

local fingerprint
fingerprint = {id= "ThermalFoundation:material", dmg = 1}

--local returnedHashes
--returnedHashes = MEfunctions.returnNBThashes(fingerprint.id, allItemsNetwork)

MEfunctions.fillChest(pulverizerInterface, "north", chestSizes.woodSingle, fingerprint, 200)
--print(returnedHashes[i])
