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

print("plep")

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
fingerprint = {id= "ThermalFoundation:material", dmg = 0}
print(fingerprint.id)
print(fingerprint["id"])

local returnedHashes
returnedHashes = MEfunctions.returnNBThashes(fingerprint.id, allItemsNetwork)
print(#returnedHashes)

for i = 1, #returnedHashes, 1 do
  fingerprint["nbt_hash"] = returnedHashes[i]
  MEfunctions.fillChest(pulverizerInterface, "north", 27, fingerprint, 64)
  print(returnedHashes[i])
end
