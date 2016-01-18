if not file.IsDir("lgp", "DATA") then
	file.CreateDir("lgp")
end

local InvalidColor = Color(180, 0, 0)
local ValidColor = Color(0, 200, 0)

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

function Editor:Save(Tab)
end

function Editor:Validate(Code, File)
	local Load = CompileString(Code, File, false)
	if type(Load) == "function" then
		self.ValidateButton.ValidationColor = ValidColor
		self.ValidateButton:SetText("No Lua errors were detected")
	elseif type(Load) == "string" then
		self.ValidateButton.ValidationColor = InvalidColor
		self.ValidateButton:SetText("Error: "..Load)
	else
		self.ValidateButton.ValidationColor = InvalidColor
		self.ValidateButton:SetText("Failed to validate")
	end
end

function Editor:AddTab(Name, Contents, Path)
	if not Name then
		if Path then
			Name = Path:match("data/lgp/(.+)%p([%u|%a])")
		end
		Name = Name or "New"
	end

	local Editor = self
	local Panel = vgui.Create("DPanel")
	local Sheet = self.Column:AddSheet(Name, Panel)
	local Tab = Sheet.Tab

	Tab.Name = Name
	Tab.Path = Path
	Tab.HTML = vgui.Create("DHTML", Panel)
	Tab.HTML:Dock(FILL)
	Tab.HTML:OpenURL("http://fi.apex.gs/luaeditor")
	Tab.HTML:SetAllowLua(true)
	timer.Create("LGP_Content", 0.5, 1,
		function ()
			Tab.HTML:RunJavascript([[SetContent(]]..string.format("%q", Contents)..[[)]])
		end
	)

	function Tab:OnMousePressed(Code, ...)
		if Code == MOUSE_RIGHT then
			local Menu = DermaMenu(self)
			Menu:AddOption("Save",
				function ()
					Editor:Save(self)
				end
			)

			Menu:AddOption("Close",
				function ()
					Editor.Column:CloseTab(self, true)
				end
			)

			Menu:Open()
		else
			self.BaseClass.OnMousePressed(self, Code, ...)
		end
	end

	function Tab:GetCode()
		self.HTML:RunJavascript("getCode()")
		return Editor.Script or ""
	end

	return Tab
end

function Editor:GetCode()
	local Tab = self.Column:GetActiveTab()
	return Tab:GetCode(), Tab.Name
end

function Editor:OnSelectFile(Path)
	self:AddTab(nil, file.Read(Path, "GAME"), Path)
end

function Editor:Init()
	local Width = 1200
	local Height = 700
	local Editor = self

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
	self.ValidateButton.ValidationColor = Color(200, 200, 200)
	function self.ValidateButton:DoClick()
		timer.Create("LGP_Validate", 0.01, 1, function () Editor:Validate(Editor:GetCode()) end)
	end

	function self.ValidateButton:Paint(w, h)
		draw.RoundedBox(5, 0, 0, w, h, self.ValidationColor)
	end

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

    self.ValidateButton:SetPos(280, Height - 30)
	self.ValidateButton:SetSize(Width - 290, 20)
end


vgui.Register("LGP_Editor", Editor, "DFrame")

concommand.Add("openlgpeditor",
	function ()
		if LGP.Editor then
			LGP.Editor:Remove()
		end
		LGP.Editor = vgui.Create("LGP_Editor")
	end
)
