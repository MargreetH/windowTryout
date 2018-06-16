print("Changing settings for the reactor.")
print("Current settings")
fileName = "reactorSettings"
local h

fileExists = fs.exists("disk/"..fileName)

function printContentsFile(file)
  nextLine = file.readLine()
  while nextLine ~= nil do
    print(nextLine)
    nextLine = file.readLine()
  end
end

if fileExists then
   h = fs.open("disk/"..fileName, 'r')
   print("File exists! Contents:")
   printContentsFile(h)
   h.close()
else
   print("Empty!")
end

local cond = true

while cond == true do
  print("Do you want to overwrite or create a file? Y/N. (N exits the program)")
  answer = read()

  if answer == "Y" then
    local cond2 = true
    h = fs.open("disk/"..fileName, 'w')

    while cond2 == true do

      print("Enter the number of a reactor. Enter -1 to exit adding reactors.")
      answer2 = read()

      if answer2 == "-1" then
        print("Stopping file editing.")
        cond2 = false
        h.close()
      else
        h.writeLine(answer2)
        print("Reactor "..answer2.." written to file.")
      end

    end

  elseif answer == "N" then
    print("Ok, see you!")
    cond = false
  else
    print("Invalid input, try again.")
  end

end
