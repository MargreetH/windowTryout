
local monitors
monitors = peripheral.wrap("right")

function newLine()
local x
local y
x, y = monitors.getCursorPos()
y = y + 1
monitors.setCursorPos(1,y)
end

function resetColors()
  monitors.setTextColor(colors.white)
  monitors.setBackgroundColor(colors.black)
end

function writeToScreen(text)
monitors.clear()
monitors.setCursorPos(1,1)
monitors.setBackgroundColor(colors.red)
monitors.write("********************************")
newLine()
monitors.write("   AE2 Monitoring program      ")
newLine()
monitors.write("********************************")
newLine()
monitors.setBackgroundColor(colors.black)
monitors.setTextColor(colors.magenta)
monitors.write("Written by Merlione404")
resetColors()
newLine()
newLine()
monitors.write("Mining coal at: 67 per minute")
newLine()
monitors.write("Average of the last 10 minutes: plip per minute")
newLine()
monitors.write(text)
end


writeToScreen("Hallo")
