AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName       = "Lua Graphics Processor"
ENT.Author          = "Matas & Sertao"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category        = "Wire"
ENT.Spawnable       = true

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate3x5.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local Phys = self:GetPhysicsObject()
	if Phys:IsValid() then
		Phys:Wake()
		Phys:SetMass(1)
	end

	if CLIENT then
		self.Received = {}
		self.ReceiveHash = ""
	end

	self.Script = ""
	self:Reset()
end

function ENT:Reset()
	-- This function is called automatically when the client finishes loading the code of the entity
end

function ENT:Think()

end

if CLIENT then
	function ENT:Render()
	end
end
