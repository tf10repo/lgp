if not file.IsDir("lgp", "DATA") then
	file.CreateDir("lgp")
end

local Editor = {}
local DefaultText = [[
Welcome to the LGP editor
]]

function Editor:NewFile()
	self = self:GetParent()
end

function Editor:OpenFile()
	self = self:GetParent()
end

function Editor:AddTab(Name, Contents, Path)
	local Tab = {}
	Tab.Path = Path
	if Name then
		Tab.Name = Name
	elseif Path then
		Tab.Name = Path:match("data/lgp/(.+)%p([%u|%a])") or "New"
	else
		Tab.Name = "New"
	end
	Tab.Panel = vgui.Create("DPanel")
	Tab.TextArea = vgui.Create("DTextEntry", Tab.Panel)

	Tab.TextArea:SetPos(5, 5)
	Tab.TextArea:SetSize(self:GetWide() - 315, self:GetTall() - 140)
	Tab.TextArea:SetMultiline(true)
	Tab.TextArea:SetTabbingDisabled(false)
	Tab.TextArea:SetFont("LGP_Text")
	if Contents then
		Tab.TextArea:SetText(Contents)
	end

	function Tab.TextArea:OnKeyCodeTyped(KeyCode)
        if KeyCode == KEY_TAB then
            self:SetText(self:GetText().."     ")
            self:SetCaretPos(#self:GetText())
            self.DoFocus = true
        end
    end

	function Tab.TextArea:OnLoseFocus(Gained)
		if self.DoFocus then
			self:RequestFocus()
			self.DoFocus = nil
		end
	end

	table.insert(self.Tab, Tab)
	self.Column:AddSheet(Tab.Name, Tab.Panel)
end

function Editor:OnSelectFile(Path)
	self:AddTab(nil, file.Read(Path, "GAME"), Path)
end

function Editor:Validate()
end

surface.CreateFont("LGP_Text",
	{
		font = "Century Gothic",
		size = 20,
	}
)

function Editor:Init()
	local Width = 1200
	local Height = 700

	self.Tab = {}

	self:SetPos(100, 100)
	self:SetSize(Width, Height)
	self:SetVisible(true)
	self:SetSizable(true)
	self:SetTitle("LGP Editor")

	self.Menu = vgui.Create("DMenuBar", self)
	self.Menu.File = self.Menu:AddMenu("File")
	self.Menu.Edit = self.Menu:AddMenu("Edit")
	self.Menu.Help = self.Menu:AddMenu("Help")

	self.Menu.File:AddOption("New", function () self:NewFile() end):SetIcon("icon16/page_white_go.png")
	self.Menu.File:AddOption("Open", function () self:OpenFile() end):SetIcon("icon16/folder_go.png")

	self.Browser = vgui.Create("DFileBrowser", self)
	self.Browser:SetPos(10, 60)
	self.Browser:SetSize(260, Height - 70)
	self.Browser:SetPath("GAME")
	self.Browser:SetBaseFolder("data/lgp")
	self.Browser:SetOpen(true)
	function self.Browser.OnSelect(FileBrowser, Path)
		self:OnSelectFile(Path)
	end

	self.Column = vgui.Create("DPropertySheet", self)
	self.Column:SetPos(280, 60)
	self.Column:SetSize(Width - 290, Height - 95)

	self.ValidateButton = vgui.Create("DButton", self)
	self.ValidateButton:SetPos(280, Height - 30)
	self.ValidateButton:SetSize(Width - 290, 20)
	self.ValidateButton:SetText("Validate")

	self:AddTab("Sample", DefaultText)
	self:MakePopup()
end

function Editor:Think()
	self:InvalidateLayout()
	self.BaseClass.Think(self)
end

function Editor:PerformLayout()
	self.BaseClass.PerformLayout(self)

	local Width , Height = self:GetWide(), self:GetTall()

	self.Browser:SetPos(10, 60)
    self.Browser:SetSize(260, Height - 70)

 	self.Column:SetPos(280, 60)
    self.Column:SetSize(Width - 290, Height - 95)

    for Index, Tab in pairs(self.Tab) do
    	Tab.TextArea:SetPos(5, 5)
    	Tab.TextArea:SetSize(Width - 315, Height - 140)
	end

    self.ValidateButton:SetPos(280, Height - 30)
	self.ValidateButton:SetSize(Width - 290, 20)
end

vgui.Register("LGP_Editor", Editor, "DFrame")

concommand.Add("openlgpeditor",
	function ()
		local Ply = LocalPlayer()
		if Ply.Editor then
			Ply.Editor:Remove()
		end
		Ply.Editor = vgui.Create("LGP_Editor")
	end
)
