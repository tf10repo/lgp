function LGP.GenerateHash()
	return ""
end

function LGP:SendEntityCode(Player)
	local Script = util.Compress(self.Script)
	local Parts = {}
	for i = 1, math.ceil(#Script / LGP.UploadSpeed) do
		table.insert(Parts, Script:sub(i * LGP.UploadSpeed, (i + 1) * LGP.UploadSpeed - 1))
	end

	local Hash = LGP.GenerateHash()

	net.Start("lgp_start_sending")
	net.WriteEntity(self)
	net.WriteString(Hash)
	net.Send(Player)

	local Delay = 0
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

function LGP:SendEntityCodeBroadcast(Entity)
	local Script = util.Compress(self.Script)
	local Parts = {}
	for i = 1, math.ceil(#Script / LGP.UploadSpeed) do
		table.insert(Parts, Script:sub(i * LGP.UploadSpeed, (i + 1) * LGP.UploadSpeed - 1))
	end

	local Hash = LGP.GenerateHash()

	net.Start("lgp_start_sending")
	net.WriteEntity(self)
	net.WriteString(Hash)
	net.Broadcast()

	local Delay = 0
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