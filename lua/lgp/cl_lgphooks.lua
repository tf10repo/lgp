function LGP.Render()
	local Entities = ents.FindByClass("gmod_wire_lgp")
	for Index, Entity in pairs(Entities) do
		Entity:Render()
	end
end

hook.Add("PostDrawTranslucentRenderables", "LGPHudPaint", LGP.Render)
