
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

function createInfoFieldStartWindow(m)
    m.setBackgroundColor(colors.orange)
  m.clear()
  m.setCursorPos(1,1)
  m.write("Welcome! What do you want to do?")
  functions.newLine(m)
  m.write("Choose one of the options from below.")
end

function createReturnButton(m)
  m.setBackgroundColor(128)
  m.setTextColor(1)
  functions.textInMiddleButton(m, "Return")
end
function createWindowSwitchPulverizer(m)
  m.setBackgroundColor(colors.gray)
  m.clear()
  m.setCursorPos(1,1)
  functions.textInMiddleButton(m,"Send stuff to pulverizer")
  functions.newLine(m)
end


function createWindowSwitchFurnace(m)
  m.setBackgroundColor(colors.brown)
  m.clear()
  m.setCursorPos(1,1)
  functions.textInMiddleButton(m,"Send stuff to furnace")
  functions.newLine(m)
end

function createLabeledButtons(G)
    print("in createfurnacebuttons")

local currentColor = 4096
  for j = 1, #G[1], 1 do
    for i = 1, #G, 1 do

      G[i][j].setTextColor(1)
      G[i][j].setBackgroundColor(currentColor)
      currentColor = toggleColor(currentColor)
      G[i][j].clear()

      if G[i][j].label ~= nil then
        functions.textInMiddleButton(G[i][j], G[i][j].label)
      end
    end
  end
end


function createProcessingWindowComponents(info, changing, success)
 info.setCursorPos(1,1)
 info.setBackgroundColor(4096)
 info.setTextColor(1)
 functions.textInMiddleButton(info, "Currently processing resources.")

 changing.setCursorPos(1,1)
 changing.setBackgroundColor(128)
 changing.setTextColor(1)

 success.setCursorPos(1,1)
 success.setBackgroundColor(2048)
 success.setTextColor(1)
 functions.textInMiddleButton(success, "Job in progress.")
end
