local versionNumber = 3.3

local args = {...}

if #args >= 1 then
	if args[1] == "setup" then
		--sane default window sizes
		local lyqwin = [[
1,1,9,4,false,rom/programs/reboot
1,1,9,4,false,rom/programs/shutdown
1,1,19,9,true,rom/programs/color/paint
3,3,47,15,false,rom/programs/shell
2,2,47,15,false,rom/programs/lua
]]
		local lyqwinPocket = [[
1,1,9,4,false,rom/programs/reboot
1,1,9,4,false,rom/programs/shutdown
1,1,19,9,true,rom/programs/color/paint
1,3,26,16,false,rom/programs/shell
1,4,26,16,false,rom/programs/lua
]]
		if pocket then lyqwin = lyqwinPocket end
		if pack then
			pack.addFile("/LyqydOS/.lyqwin", lyqwin)
		else
			if not fs.exists("/LyqydOS/.lyqwin") then
				local handle = io.open("/LyqydOS/.lyqwin", "w")
				if handle then
					handle:write(lyqwin)
					handle:close()
				end
			end
		end
		print("Run LyqydOS on startup? (y/N)")
		term.write("> ")
		local input = io.read()
		if #input > 0 then
			input = string.lower(string.sub(input, 1, 1))
			if input == "y" then
				local handle
				if fs.exists("/startup") then
					handle = io.open("/startup", "a")
				else
					handle = io.open("/startup", "w")
				end
				if handle then
					handle:write([[shell.run("/LyqydOS/procman")]].."\n")
					handle:close()
				end
			end
		end
	elseif args[1] == "remove" then
		if pack then
			pack.removeFile("/LyqydOS/.config")
			pack.removeFile("/LyqydOS/.lyqrunhistory")
			pack.removeFile("/LyqydOS/.lyqshellrunhistory")
			pack.removeFile("/LyqydOS/.lyqwin")
		else
			if fs.exists("/LyqydOS/.config") then fs.delete("/LyqydOS/.config") end
			if fs.exists("/LyqydOS/.lyqrunhistory") then fs.delete("/LyqydOS/.lyqrunhistory") end
			if fs.exists("/LyqydOS/.lyqshellrunhistory") then fs.delete("/LyqydOS/.lyqshellrunhistory") end
			if fs.exists("/LyqydOS/.lyqwin") then fs.delete("/LyqydOS/.lyqwin") end
		end
	end
else
	--get packman and use it.


	local otherHTTPs = {"https://raw.githubusercontent.com/MargreetH/windowTryout/master/windowTest.lua",
	"https://raw.githubusercontent.com/MargreetH/windowTryout/master/scripts/functions.lua",
	"https://raw.githubusercontent.com/MargreetH/windowTryout/master/reactorControlWithTouch.lua",
	"https://raw.githubusercontent.com/MargreetH/windowTryout/master/reactorSettings.lua",
	 "https://raw.githubusercontent.com/MargreetH/windowTryout/master/AE2monotoring.lua",
	 "https://raw.githubusercontent.com/MargreetH/windowTryout/master/AE2MainProgram.lua",
  "https://raw.githubusercontent.com/MargreetH/windowTryout/master/scripts/MEfunctions.lua",
"https://raw.githubusercontent.com/MargreetH/windowTryout/master/data/fingerprints.lua",
"https://raw.githubusercontent.com/MargreetH/windowTryout/master/snake.lua"}

	local otherpaths = {"/git", "/git/scripts", "/git", "/git", "/git","/git", "/git/scripts", "/git/data", "/git"}
	local fileName = {"windowTest", "functions", "reactor", "reactorSettings", "AE2", "AE2MainProgram", "MEfunctions", "fingerprints", "snake"}

	for i=1, #fileName, 1 do

		local response = http and http.get(otherHTTPs[i])
		if response then
			if not fs.exists(otherpaths[i]) then fs.makeDir(otherpaths[i]) end
			local handle = io.open(otherpaths[i].."/"..fileName[i], "w")
			if handle then
				handle:write(response.readAll())
				handle:close()
			else
				error("Could not write ")
			end
			response.close()
		else
			error("Could not fetch file")
		end

	end




end
