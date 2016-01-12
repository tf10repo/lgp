TOOL.Category = "LGP"
TOOL.Name = "#LGP"
TOOL.Command = nil
TOOL.ConfigName = ""
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
	local tr = util.TraceLine(
		{
			start = trace.HitPos,
			endpos = trace.HitPos + Vector(0,0, 10000),
			filter = function( ent )
				if ent:GetClass() == "prop_physics" then
					return true
				end
			end
		}
	)

	local iNum = self:NumObjects()
	local Phys = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
	self:SetObject( iNum + 1, tr.Entity, tr.HitPos, Phys, tr.PhysicsBone, tr.HitNormal )

	if iNum > 0 then
		self.Pos1,self.Pos2 = self:GetPos(1) , self:GetPos(2)
		self:ClearObjects()
	else
		self:SetStage(iNum + 1)
	end
	return true
end

function TOOL:BuildCPanel( panel )

end

function TOOL:Reload()

end
