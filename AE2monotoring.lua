--Add needed functions
os.loadAPI("/git/scripts/functions")


--Monitors stuff
local monitors
monitors = peripheral.wrap("left")

local timeSteps = 10
local counter = 0

--Loading screen
monitors.clear()
monitors.setCursorPos(1,1)
monitors.write("Loading....")

local AE2
AE2 = peripheral.wrap("tileinterface_6")
local items
local numberOfItems

--Items to be monitored
--SET THESE YOURSELF
local itemsToBeMonitored = {"minecraft:coal", "appliedenergistics2:item.ItemMultiMaterial:1", "DraconicEvolution:draconiumIngot", "minecraft:cobblestone","minecraft:redstone"}
local labels = {"coal", "charged certus", "draconium", "cobblestone", "redstone"}
local itemObjects
itemObjects = functions.vector(#itemsToBeMonitored)

--The matrices that track the speed differences
local speeds = functions.vector(#itemsToBeMonitored)
local pastSpeeds = functions.matrix(#itemsToBeMonitored, timeSteps)
local averageSpeeds = functions.vector(#itemsToBeMonitored)

function regetItems()
items = AE2.getAvailableItems(1)
numberOfItems = #items
end

function getAverages()
local sum
for i = 1, #itemsToBeMonitored, 1 do
	sum = 0
	for j = 1, #pastSpeeds[i], 1 do
		sum = sum + pastSpeeds[i][j]
	end
	averageSpeeds[i] = sum / #pastSpeeds[i]
end
end

function printColoredNumber(number)
	if number < 0 then
		monitors.setTextColor(colors.red)
	elseif number < 10 then
		monitors.setTextColor(colors.yellow)
	elseif number < 40 then
	monitors.setTextColor(colors.green)
  else
monitors.setTextColor(colors.lime)
  end
monitors.write(number)
functions.resetColors(monitors)
end

function writeToScreen(text)
	--Resetting screen
  functions.resetColors(monitors)
	monitors.clear()
	monitors.setCursorPos(1,1)
	--Header
	monitors.setBackgroundColor(colors.red)
	monitors.write("********************************")
	functions.newLine(monitors)
	monitors.write("   AE2 Monitoring program      ")
	functions.newLine(monitors)
	monitors.write("********************************")
	functions.newLine(monitors)
	monitors.setBackgroundColor(colors.black)
	monitors.setTextColor(colors.magenta)
	monitors.write("Written by Merlione404")
	functions.resetColors(monitors)
	--Real information
functions.newLine(monitors)
functions.newLine(monitors)

--Write something for each item to be monitored
for i = 1, #itemsToBeMonitored, 1 do
	monitors.write("Current "..labels[i].." rate: ")
	printColoredNumber(speeds[i])
	monitors.write("/minute")
	functions.newLine(monitors)
	if counter < timeSteps then
		monitors.write("Time average not yet available.")
	else
		monitors.write("Average of the last 10 minutes: "..averageSpeeds[i].." per minute")
	end
	functions.newLine(monitors)
end

monitors.write(text)
end

function getNBTHash(itemname)
    regetItems()
		for i = 1, numberOfItems, 1 do
   		if items[i].fingerprint.id == itemname then
			return items[i].fingerprint.nbt_hash
		end
		end
end

regetItems()

-- Get hashes for all the items and create the item objects
for i = 1, #itemsToBeMonitored, 1 do
	--Gets the hash for each items
	hash = getNBTHash(itemsToBeMonitored[i])

	local tempItem = {id = itemsToBeMonitored[i], dmg = 0, nbt_hash = hash}
	itemObjects[i] = tempItem
end

local oldAmount = functions.vector(#itemsToBeMonitored)

function getAmounts()
	tempVec = functions.vector(#itemsToBeMonitored)
	for i = 1, #itemsToBeMonitored, 1 do
		tempVec[i]= AE2.getItemDetail(itemObjects[i] , false).qty
	end
	return tempVec
end

while true do
 oldAmount = getAmounts()
 sleep(60)
 newAmount = getAmounts()
 speeds = functions.vectorMinus(newAmount,oldAmount)

 for i = 1, #itemsToBeMonitored, 1 do
	 pastSpeeds[i] = functions.addToList(pastSpeeds[i], speeds[i])
 end
getAverages()
counter = counter + 1
writeToScreen(".....")
end
