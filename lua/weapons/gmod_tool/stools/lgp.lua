TOOL.Category = "lgp"
TOOL.Name = "lgp"
TOOL.Command = nil

if CLIENT then
	language.Add("tool.lgp.name", "Lua Graphics Processor")
	language.Add("tool.lgp.0", "Left Click: spawn a LGP Right Clcik: open editor")
	language.Add("tool.lgp.desc", "EGP but Lua")
elseif SERVER then
	CreateConVar('sbox_maxwire_lgp', 20)
end

TOOL.Boxes = {}
TOOL.Strings = {}

function TOOL:LeftClick( trace )
	-- Spawn a LGP
	return true
end

function TOOL:RightClick( trace )
	local Owner = self:GetOwner()
	if IsValid(Owner) and Owner:IsAdmin() then
		Owner:ConCommand("openlgpeditor")
	end
	return true
end

if CLIENT then
	function TOOL:BuildCPanel(panel)
		local FileBrowser = vgui.Create("wire_expression2_browser", panel)
		FileBrowser.OpenOnSingleClick = wire_expression2_editor
		panel:AddPanel(FileBrowser)

		FileBrowser:Setup("lgp")
		FileBrowser:SetSize(w, 300)
		FileBrowser:DockMargin(5, 5, 5, 5)
		FileBrowser:DockPadding(5, 5, 5, 5)
		FileBrowser:Dock(TOP)

		function FileBrowser:OnFileOpen(filepath, newtab)
			game.ConsoleCommand("openlgpeditor\n")
		end
	end
end

function TOOL:Reload()
end
