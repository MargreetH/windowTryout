--Main program for AE2 stuff

--Add needed functions
os.loadAPI("/git/scripts/functions")
os.loadAPI('/git/scripts/MEfunctions')

--Monitors stuff
local monitors
monitors = peripheral.wrap("left")

--Loading screen
monitors.clear()
monitors.setCursorPos(1,1)
monitors.write("Loading....")

--Get the interfaces that are used from the network
local pulverizerInterface
pulverizerInterface = peripheral.wrap("tileinterface_5")

--Some variables used
local allItemsNetwork --A list of all items in the ME network,
local numberOfItemTypesNetwork -- The number of different items in the network

--Gets a list of all items in system
function regetItems()
  allItemsNetwork = pulverizerInterface.getAvailableItems(1)
  numberOfItemTypesNetwork = #items
end

fingerprint = {id= "ThermalFoundation:material", dmg = 0}
local returnedHashes
returnedHashes = MEfunctions.returnNBTHashes(fingerprint["id"])

for i = 1, #returnedHashes, 1 do
  fingerprint["nbt_hash"] = returnedHashes[i]
  MEfunctions.fillChest(pulverizerInterface, "north", 27, fingerprint, 64)
end
