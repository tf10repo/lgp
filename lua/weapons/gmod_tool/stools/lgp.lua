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
	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	if iNum > 0 then
		self:ClearObjects()
	else
		self:SetStage( iNum + 1 )
	end
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
