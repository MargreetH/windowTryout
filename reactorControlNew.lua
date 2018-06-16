os.loadAPI("scripts/functions")
local m
m = peripheral.wrap("right")

-- Some constants
energyTreshold = 2000000
justTurnedAllReactorsOff = false
offlineTime = 60
sleepTime = 5

-- Read settings file for reactor numbers
local reactorNumbers = {}
local reactorOnline = {}
local reactors = {}
local h  = fs.open("disk/reactorSettings", 'r')
local line = h.readLine()
counter1 = 1
while line ~= nil do
  reactorNumbers[counter1] = line
  reactorOnline[counter1] = true
  reactors[counter1] = peripheral.wrap("BigReactors-Reactor_"..reactorNumbers[counter1])
  line = h.readLine()
  counter1 = counter1 + 1
end
h.close()

-- Wrap all the reactors connected to network

for i = 1, #reactorNumbers, 1 do

end

--Function that checks what to do with a reactor
-- 1 : reactor off, no energy stored
-- 2: reactor off, energy stored > treshold
--
function handleReactor(reactor, index)
  local active = reactor.getActive()
  local energy = reactor.getEnergyStored()

  if active then
    if energy > energyTreshold then
      reactor.setActive(false)
      reactorOnline[index] = false
      print("Stopped reactor "..index)
    end
  else
    if energy < energyTreshold then
      reactor.setActive(true)
      reactorOnline[index] = true
      print("Started reactor "..index)
    end
  end
end

function checkAllReactorsOffline()
  for i = 1, #reactorNumbers, 1 do
    if reactorOnline[i] == true then
      return false
    end
  end
  return true
end

local waitLonger = false
--Main loop
while true do

  for i = 1, #reactors, 1 do
    handleReactor(reactors[i], i)
  end

  waitLonger = checkAllReactorsOffline()

  if waitLonger then
    sleep(offlineTime)
  else
    sleep(sleepTime)
  end

end


--Display something to test if this works so far
for i = 1, #reactorNumbers, 1 do
  print(reactors[i].getEnergyStored())
end
