function touchEvent(xPos, yPos)

end


function processEvents(event)

  if event[1] == "monitor_touch" then
    touchEvent(event[3], event[4])
  else if event[1] == "key" then
    functions.printTableToTerminal(event)
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

print("plap")


local mainBoolean = true

while mainBoolean do
print(term.getSize())
wait(0.2)
end
