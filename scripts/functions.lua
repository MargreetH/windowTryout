--All functions to be used

--Matrix (?)
function matrix(M,N)
local mt
mt = {}
for i=1,M do
  mt[i] = {}
  for j=1,N do
    mt[i][j] = 0
  end
end
return mt
end


function vector(N)
local mt
mt = {}
for i=1,N do
	mt[i] = 0
end
return mt
end

function vectorMinus(vec1,vec2)
tempVec = vector(#vec1)
	for i = 1, #vec1, 1 do
		tempVec[i]= vec1[i] - vec2[i]
	end
	return tempVec
end

function resetColors(monitors)
  monitors.setTextColor(colors.white)
  monitors.setBackgroundColor(colors.black)
end

function newLine(monitors)
local x
local y
x, y = monitors.getCursorPos()
y = y + 1
monitors.setCursorPos(1,y)
end

function addToList(table, number)
	for i = 1, #table - 1, 1 do
		j = i + 1
		table[i] = table[j]
	end
	table[#table] = number
return table
end


--Subdivides regions on the screen
function subDivideRegion(x, y, width, height, parts, divideVertically)

  local returnTable = {}

  -- Initialize the return table
  for i = 1, parts, 1 do
    returnTable[i] = {}
  end

  local sum = 0

  if divideVertically then -- Make columns
    widthSplit = math.floor(width / parts)
    for i = 1, parts, 1 do
      returnTable[i]["x"] = 1 + widthSplit * (i-1)
      returnTable[i]["y"] = y
      returnTable[i]["width"] = widthSplit
      returnTable[i]["height"] = height
      sum = sum + widthSplit
    end
    returnTable[parts]["width"] = returnTable[parts]["width"] + width - sum
    return returnTable
  end

-- other case, make rows
heightSplit = math.floor(height / parts)
for i = 1, parts, 1 do
  returnTable[i]["x"] = x
  returnTable[i]["y"] = 1 + heightSplit * (i-1)
  returnTable[i]["width"] = width
  returnTable[i]["height"] = heightSplit
  sum = sum + heightSplit
end

returnTable[parts]["height"] = returnTable[parts]["height"] + height - sum
return returnTable
end


function returnWindows(m, x, y, width, height, parts, divideVertically)

  local coordinateTable = subDivideRegion(x, y, width, height, parts, divideVertically)
  local returnTable = {}

  for i = 1, parts, 1 do
    returnTable[i] = window.create(m, coordinateTable[i]["x"], coordinateTable[i]["y"], coordinateTable[i]["width"], coordinateTable[i]["height"])
  end

  return returnTable
end

function checkInRangeWindow(w, xPos, yPos)
  local wxPos, wyPos = w.getPosition()
  local width, height = w.getSize()
  xlimit = wxPos + width
  ylimit = wyPos + height

  if xPos < wxPos then return false end
  if yPos < wyPos then return false end
  if xPos > xlimit then return false end
  if yPos > ylimit then return false end
  return true
end


function fillButton(w, text)
  w.write(".......................................")
  newLine(w)
  w.write(".... "..text.." ..........................")
  newLine(w)
  w.write(".......................................")
end
