﻿local T, C, L, G = unpack( Tukui )

if not IsAddOnLoaded("Skada") or C.skin.skadareskin ~= true then return end

local Skada = Skada

local Skada = Skada
local barSpacing = T.Scale(1, 1)
local borderWidth = T.Scale(2, 2)

local barmod = Skada.displays["bar"]

local function StripOptions(options)
	options.baroptions.args.barspacing = nil
	options.titleoptions.args.texture = nil
	options.titleoptions.args.bordertexture = nil
	options.titleoptions.args.thickness = nil
	options.titleoptions.args.margin = nil
	options.titleoptions.args.color = nil
	options.windowoptions = nil
	options.baroptions.args.barfont = nil
	options.titleoptions.args.font = nil
end

local barmod = Skada.displays["bar"]
barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
barmod.AddDisplayOptions = function(self, win, options)
	self:AddDisplayOptions_(win, options)
	StripOptions(options)
end

for k, options in pairs(Skada.options.args.windows.args) do
	if(options.type == "group") then
		StripOptions(options.args)
	end
end

local titleBG = {
	bgFile = C["media"].normTex,
	tile = false,
	tileSize = 0
}

barmod.ApplySettings_ = barmod.ApplySettings
barmod.ApplySettings = function(self, win)
	barmod.ApplySettings_(self, win)

	local skada = win.bargroup

	if(win.db.enabletitle) then
		skada.button:SetBackdrop(titleBG)
	end

	skada:SetTexture(C["media"].normTex)
	skada:SetSpacing(barSpacing)
	skada:SetFont(C["media"].font, 12)
	skada:SetFrameLevel(5)
	
	if not skada.TitleBackGround then
		skada.TitleBackGround = CreateFrame("Frame", nil, skada.button)
		skada.TitleBackGround:SetPoint("TOP")
		skada.TitleBackGround:SetPoint("LEFT")
		skada.TitleBackGround:SetPoint("RIGHT")
		skada.TitleBackGround:SetPoint("BOTTOM", 0, 1)
		skada.TitleBackGround:SetTemplate( "Default" )
		skada.TitleBackGround:SetFrameLevel(skada.button:GetFrameLevel() -1)
	end
	
	local titlefont = CreateFont("TitleFont" .. win.db.name)
	titlefont:SetFont(C["media"].font, 12, "OUTLINE")
	skada.button:SetNormalFontObject(titlefont)

	local color = win.db.title.color
	skada.button:SetBackdropColor(0, 0, 0, 0)

	skada:SetBackdrop(nil)
	if not skada.backdrop then
		skada:CreateBackdrop("Default")
	end
	skada.backdrop:ClearAllPoints()
	if(win.db.enabletitle) then
		skada.backdrop:Point("TOPLEFT", skada.button, "TOPLEFT", -2, 2)
	else
		skada.backdrop:Point("TOPLEFT", skada, "TOPLEFT", -2, 2)
	end
	skada.backdrop:Point("BOTTOMRIGHT", skada, "BOTTOMRIGHT", 2, -2)

end

local function EmbedWindow(window, width, barheight, height, point, relativeFrame, relativePoint, ofsx, ofsy)
	window.db.barwidth = width
	window.db.barheight = barheight
	if( window.db.enabletitle ) then 
		height = height - barheight
	end
	window.db.background.height = height
	window.db.spark = false
	window.db.barslocked = true
	window.bargroup:ClearAllPoints()
	window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
	
	barmod.ApplySettings(barmod,window)
end
