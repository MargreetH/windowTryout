os.loadAPI("/git/scripts/functions")
os.loadAPI('/git/data/fingerprints')


print("plap")

local soulsandSlots = {}
local witherSlots = {}

local allSlotDetails = {}
local allSlotAmounts = {}

for i = 1, 16, 1 do
  allSlotDetails[i] = turtle.getItemDetail(i)
  allSlotAmounts[i] = turtle.getItemCount(i)
end

functions.printTableToTerminal(allSlotDetails[1])
functions.printTableToTerminal(allSlotDetails[2])
functions.printTableToTerminal(allSlotDetails[3])
