local m
m = peripheral.wrap("left")
m.clear()
os.loadAPI("/git/scripts/functions")
local timeTick = 1

--Some constants
local longString = "sahadhgsahsdjasdasdahsdjkashdjkashdkjsahdjkahsjkdhaskjdhaksjdhajksdsasdkaksdkhdsajkdfsdfadsdasd"

screenSize = m.getSize()
--Create windows
topPart = window.create(m, 1,1, 50, 4)
topPart.setCursorPos(1, 1)

infoField = window.create(m, 1,5, 50, 3)
infoField.setCursorPos(1, 1)

textField = window.create(m, 1,9, 50, 20)

createdWindows = functions.returnWindows(m, 1, 30, 50, 3, 3, true)

local switchButton = createdWindows[1]
local viewHistoryButton = createdWindows[2]
local exitButton = createdWindows[3]

topPart.setBackgroundColor(16384)
topPart.setTextColor(1)
textField.setBackgroundColor(32)



function createTopPart(w)
  w.setBackgroundColor(16384) --Red
  w.setTextColor(32768) --Black
  w.write("****************************************************************")
  functions.newLine(w)
  w.write("***********  REACTOR CONTROL PROGRAM  ********************************")
  functions.newLine(w)
  w.write("****************************************************************")
  functions.newLine(w)
  w.setTextColor(64) --Pink
  w.setBackgroundColor(32768) --Black
  w.write("Written by Merlione404")
end

function fillWindow(w, bgcolor)
  w.setBackgroundColor(bgcolor) --Red
  w.setTextColor(32768) --Black
  for i = 1, 80, 1 do
    w.write(longString)
    functions.newLine(w)
  end
end

function exitButtonClick()
  m.clear()
 os.exit(0)
end

function switchButtonClick()
  infoField.clear()
  infofield.setCursorPos(1,1)
  infoField.write("Pressed switch button")
end

function viewHistoryButtonClick()
  infoField.clear()
    infofield.setCursorPos(1,1)
  infoField.write("Pressed switch button")
end


createTopPart(topPart)
fillWindow(textField, 64)
switchButton.setBackgroundColor(2)
viewHistoryButton.setBackgroundColor(4)
exitButton.setBackgroundColor(8)
infoField.setBackgroundColor(1024)




functions.fillButton(switchButton, "SWITCH")
functions.fillButton(viewHistoryButton, "VIEW HISTORY")
functions.fillButton(exitButton, "EXIT")

counter2 = 0

textField.clear()


function touchEvent(xPos, yPos)

  local enummy = 0
  local bool = false
  bool = functions.checkInRangeWindow(switchButton, xPos, yPos)
  if bool then enummy = 1 bool = false end
  bool = functions.checkInRangeWindow(viewHistoryButton, xPos, yPos)
  if bool then enummy = 2 bool = false end
  bool = functions.checkInRangeWindow(exitButton, xPos, yPos)
  if bool then enummy = 3 bool = false end

  if enummy == 1 then
    switchButtonClick()
  elseif enummy == 2 then
    viewHistoryButtonClick()
  elseif enummy == 3 then
    exitButtonClick()
  end
end


function processEvents(event)

  if event[1] == "monitor_touch" then
    touchEvent(event[3], event[4])
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

textField.setTextColor(32768)
textField.setCursorPos(1, 1)



while true do

  if counter2 == 20 then
    textField.setCursorPos(1, 1)
    textField.clear()
  end

  wait(timeTick)
  textField.write(tostring(counter2))
  functions.newLine(textField)

  topPart.clear()



  counter2 = counter2 + 1
end