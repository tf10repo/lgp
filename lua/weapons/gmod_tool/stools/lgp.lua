TOOL.Category = "Lua Graphics Processor"
TOOL.Name = "LGP"
TOOL.Command = nil

if CLIENT then
	language.Add("tool.lgp.name", "Lua Graphics Processor")
	language.Add("tool.lgp.0", "Left Click: spawn a LGP Right Clcik: open editor")
	language.Add("tool.lgp.desc", "EGP but Lua")
elseif SERVER then
	CreateConVar('sbox_maxwire_lgp', 20)
end

cleanup.Register("wire_lgps")

TOOL.Boxes = {}
TOOL.Strings = {}

if SERVER then

	local function MakeWireLGP(Owner, Model, Angle, Position)
		local LGP = ents.Create("gmod_wire_lgp")
		LGP:SetPlayer(Owner)
		--LGP:SetOWner(Owner)
		--LGP:SetAngles(Angle)
		LGP:SetPos(Position)

		LGP:Spawn()

		Owner:AddCount( "wire_lgps", LGP )

		return LGP
	end

	function TOOL:LeftClick( trace )
		local Owner = self:GetOwner()
		if IsValid(Owner) and Owner:IsAdmin() then
			MakeWireLGP(Owner, nil, trace.Angle, trace.HitPos)
		end
		return true
	end

	function TOOL:RightClick( trace )
		local Owner = self:GetOwner()
		if IsValid(Owner) and Owner:IsAdmin() then
			Owner:ConCommand("openlgpeditor")
		end
		return true
	end

elseif CLIENT then

	function TOOL.BuildCPanel(panel)
		local FileBrowser = vgui.Create("wire_expression2_browser", panel)
		function FileBrowser.OnFileOpen(_, filepath, newtab)
			RunConsoleCommand("openlgpeditor", filepath, newtab)
		end
		
		FileBrowser:Setup("lgp")
		FileBrowser:SetSize(w, 300)
		FileBrowser:DockMargin(5, 5, 5, 5)
		FileBrowser:DockPadding(5, 5, 5, 5)
		FileBrowser:Dock(TOP)
		
		panel:AddPanel(FileBrowser)
	end

end

function TOOL:Reload()
end
