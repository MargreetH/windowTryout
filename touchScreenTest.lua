m = peripheral.wrap("right")
m.clear()
while true do
  event, side, xPos, yPos = os.pullEvent("monitor_touch")
  print(event .. " => Side: " .. tostring(side) .. ", " ..
    "X: " .. tostring(xPos) .. ", " ..
    "Y: " .. tostring(yPos))
end
