AddCSLuaFile()

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

	if CLIENT then
		self.Received = {}
		self.ReceiveHash = ""
	end

	self.Script = ""
	self:Reload()
end

function ENT:Reset()
	-- This function is called automatically when the client finishes loading the code of the entity
end

function ENT:Think()

end

if SERVER then
	function ENT:SendCodeTo(Player, Delay)
		local Script = util.Compress(self.Script)
		local Parts = {}
		for i = 1, math.ceil(#Script / LGP.UploadSpeed) do
			table.insert(Parts, Script:sub(i * LGP.UploadSpeed, (i + 1) * LGP.UploadSpeed - 1))
		end

		local Hash = ""

		net.Start("lgp_start_sending")
		net.WriteEntity(self)
		net.WriteString(Hash)
		net.Send(Player)

		for i, Part in pairs(Parts) do
			timer.Simple(Delay,
				function ()
					if Player:IsValid() then
						net.Start("lgp_receive_script")

						net.WriteEntity(self)
						net.WriteString(Hash)

						net.WriteInt(i)
						net.WriteInt(#Parts)
						net.WriteString(Part)

						net.Send(Player)
					end
				end
			)
			Delay = Delay + 0.2
		end

		return Delay
	end

	function ENT:SendCodeAll(Player, Delay)
		local Script = util.Compress(self.Script)
		local Parts = {}
		for i = 1, math.ceil(#Script / LGP.UploadSpeed) do
			table.insert(Parts, Script:sub(i * LGP.UploadSpeed, (i + 1) * LGP.UploadSpeed - 1))
		end

		local Hash = ""

		net.Start("lgp_start_sending")
		net.WriteEntity(self)
		net.WriteString(Hash)
		net.Broadcast()

		for i, Part in pairs(Parts) do
			timer.Simple(Delay,
				function ()
					if Player:IsValid() then
						net.Start("lgp_receive_script")

						net.WriteEntity(self)
						net.WriteString(Hash)

						net.WriteInt(i)
						net.WriteInt(#Parts)
						net.WriteString(Part)

						net.Broadcast()
					end
				end
			)
			Delay = Delay + 0.2
		end

		return Delay
	end
end
