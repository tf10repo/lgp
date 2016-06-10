function LGP.Spawn(Player)
	local Delay = 0
	for _, Entity in pairs(ents.FindByClass("gmod_wire_lgp")) do
		Delay = Entity:SendCodeTo(Player, Delay)
	end
end

hook.Add("PlayerInitialSpawn", "LGP_Spawn", LGP.Spawn)
