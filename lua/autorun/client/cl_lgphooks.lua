LGP = LGP or {}

function LGP.HUDPaint()
	local Entities = ents.FindByClass("gmod_wire_lgp")
	for Index, Entity in pairs(Entities) do
		Entity:HUDPaint()
	end
end

hook.Add("HUDPaint", "LGPHudPaint", LGP.HUDPaint)
