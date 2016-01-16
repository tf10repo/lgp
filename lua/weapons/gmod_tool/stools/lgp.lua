TOOL.Category = "lgp"
TOOL.Name = "lgp"
TOOL.Command = nil

if CLIENT then
	language.Add("tool.lgp.name", "Lua Graphics Processor")
	language.Add("tool.lgp.0", "LEFT CLICK: spawn a LGP RIGHT CLICK: open editor")
	language.Add("tool.lgp.desc", "EGP but lua")
end

TOOL.Boxes = {}
TOOL.Strings = {}

function TOOL:LeftClick( trace )
	-- Spawn a LGP
	return true
end

function TOOL:RightClick( trace )
	local Owner = self:GetOwner()
	if IsValid(Owner) and Owner:IsAdmin() then
		Owner:ConCommand("openlgpeditor")
	end
	return true
end

function TOOL:BuildCPanel( panel )
end

function TOOL:Reload()
end
