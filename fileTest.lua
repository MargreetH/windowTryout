print("Specify the file name")
fileName = read()
local h = fs.open("disk/"..fileName, fs.exists("disk/"..fileName) and "a" or "w")
h.close()
