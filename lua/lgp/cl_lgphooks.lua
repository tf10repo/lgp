function LGP.Render()
	local Entities = ents.FindByClass("gmod_wire_lgp")
	for Index, Entity in pairs(Entities) do
		if IsValid(Entity) then
			Entity:Render()
		end
	end
end

hook.Add("PostDrawTranslucentRenderables", "LGPHudPaint", LGP.Render)

function LGP.StartSending()
	local Entity = net.ReadEntity()
	local Hash = net.ReadString()

	Entity.Received = {}
	Entity.ReceiveHash = Hash
end

net.Receive("lgp_start_sending", LGP.StartSending)

function LGP.ReceiveScript()
	local Entity = net.ReadEntity()
	local Hash = net.ReadString()

	local Index = net.ReadInt()
	local TopIndex = net.ReadInt()
	local Part = net.ReadString()

	if #Hash > 0 and Hash == Entity.ReceiveHash then
		Entity.Received[Index] = Part

		if #Entity.Received == TopIndex then
			Entity.ReceiveHash = nil
			Entity.Received = nil

			Entity:Reset()
		end
	end
end

net.Receive("lgp_receive_script", LGP.ReceiveScript)
