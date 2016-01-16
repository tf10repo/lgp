LGP = {}
LGP.__index = LGP

if CLIENT then
	include("lgp/cl_lgpeditor.lua")
	include("lgp/cl_lgphooks.lua")
elseif SERVER then
	AddCSLuaFile("lgp/cl_lgpeditor.lua")
	AddCSLuaFile("lgp/cl_lgphooks.lua")
end

