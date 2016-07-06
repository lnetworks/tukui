local T, C, L = select(2, ...):unpack()

local TukuiUnitFrames = T["UnitFrames"]
local Class = select(2, UnitClass("player"))

if (Class ~= "DRUID") then
    return
end

TukuiUnitFrames.AddClassFeatures["DRUID"] = function(self)
    local DruidMana = CreateFrame("StatusBar", self:GetName()..'DruidMana', self.Health)
    local Font = T.GetFont(C["UnitFrames"].Font)
    local PowerTexture = T.GetTexture(C["UnitFrames"].PowerTexture)

    -- Druid Mana
    DruidMana:SetFrameStrata(self:GetFrameStrata())
    DruidMana:SetFrameLevel(self:GetFrameLevel())
    DruidMana:Size(C.UnitFrames.Portrait and 214 or 250, 8)
    DruidMana:Point("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 0, 0)
    DruidMana:SetStatusBarTexture(PowerTexture)
    DruidMana:SetStatusBarColor(0.30, 0.52, 0.90)
    DruidMana:SetFrameLevel(self.Health:GetFrameLevel() + 3)
    DruidMana:SetBackdrop(TukuiUnitFrames.Backdrop)
    DruidMana:SetBackdropColor(0, 0, 0)
    DruidMana:SetBackdropBorderColor(0, 0, 0)

    DruidMana.Background = DruidMana:CreateTexture(nil, "BORDER")
    DruidMana.Background:SetAllPoints()
    DruidMana.Background:SetColorTexture(0.30, 0.52, 0.90, 0.2)

    -- Register
    self.DruidMana = DruidMana
    self.DruidMana.bg = DruidMana.Background
end
