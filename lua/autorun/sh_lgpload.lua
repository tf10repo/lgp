LGP = {}
LGP.__index = LGP

function LGP.Print(Message)
	PrintMessage(HUD_PRINTTALK, "[LGP] "..Message)
end

if CLIENT then
	-- Run all the cl_ files
	for _, Filename in SortedPairs(file.Find("lgp/cl_*.lua", "LUA"), true) do
		include("lgp/"..Filename)
	end

	-- Run all the sh_ files
	for _, Filename in SortedPairs(file.Find("lgp/sh_*.lua", "LUA"), true) do
		include("lgp/"..Filename)
	end
elseif SERVER then
	-- Run all the sv_ files
	for _, Filename in SortedPairs(file.Find("peelpad/sv_*.lua", "LUA"), true) do
		include("lgp/"..Filename)
	end

	-- Transfer all the cl_ files to the client
	for _, Filename in SortedPairs(file.Find("peelpad/cl_*.lua", "LUA"), true) do
		AddCSLuaFile("lgp/"..Filename)
	end

	-- Transfer all the sh_ files to the client, and run them
	for _, Filename in SortedPairs(file.Find("peelpad/sh_*.lua", "LUA"), true) do
		AddCSLuaFile("lgp"..Filename)
		include("lgp/"..Filename)
	end
end
