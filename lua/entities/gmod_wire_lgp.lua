ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName       = "Lua Graphics Processor"
ENT.Author          = "Matías & Sertao"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category        = "Wire"
ENT.Spawnable       = true

function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate3x5.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

    local Phys = self:GetPhysicsObject()
	if Phys:IsValid() then
		Phys:Wake()
		Phys:SetMass(1)
	end

	self:Reload()
end

function ENT:Think()

end
