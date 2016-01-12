ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName       = "Lua Graphics Processor"
ENT.Author          = "Matías & Sertao"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category        = "Wire"
ENT.Spawnable       = true

util.AddNetworkString("LGP_TriggerInput")

if CLIENT then
	net.Receive("LGP_TriggerInput",
		function (Length)
			local Entity = net.ReadEntity()
			if IsValid(Entity) and Entity:GetClass() == "gmod_wire_lgp" then
				local Input = net.ReadString()
				local ValueType = net.ReadByte()
				local Value = net.ReadType(ValueType)

				if Input and Value then
					self:TriggerInput(Input, Value)
				end
			end
		end
	)
end

function ENT:Initialize()
	--self:SetModel( "models/hunter/plates/plate3x5.mdl" )
	--self:PhysicsInit( SOLID_VPHYSICS )
	--self:SetMoveType( MOVETYPE_VPHYSICS )
	--self:SetSolid( SOLID_VPHYSICS )
	--self:SetUseType(SIMPLE_USE)

    --local Phys = self:GetPhysicsObject()
	--if Phys:IsValid() then
	--	Phys:Wake()
	--	Phys:SetMass(1)
	--end

	self:Reload()
end

if CLIENT then

	function ENT:Reload()
		self.HudObjects = {}
		self.MapObjects = {}
		self.Environment = {}
	end

	function ENT:HUDPaint()
	end

	function ENT:TriggerInput(Name, Value)
	end

elseif SERVER then

	function ENT:Reload()
		-- Look for wire inputs on the code
		-- Adjust wire inputs
	end

	function ENT:TriggerInput(Name, Value)
		net.Start("LGP_TriggerInput")
		net.WriteString(Name)
		net.WriteByte(TypeID(Value))
		net.WriteType(Value)
	end
end

function ENT:Think()

end
