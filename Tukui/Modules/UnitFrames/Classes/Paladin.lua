local T, C, L = select(2, ...):unpack()

local TukuiUnitFrames = T["UnitFrames"]
local Class = select(2, UnitClass("player"))

if (Class ~= "PALADIN") then
    return
end

TukuiUnitFrames.AddClassFeatures["PALADIN"] = function(self)
    local HPBar = CreateFrame("Frame", self:GetName()..'HolyPower', self)
    local Shadow = self.Shadow
    local PowerTexture = T.GetTexture(C["UnitFrames"].PowerTexture)

    -- Holy Power
    HPBar:SetFrameStrata(self:GetFrameStrata())
    HPBar:SetFrameLevel(self:GetFrameLevel())
    HPBar:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 1)
    HPBar:Size(250, 8)
    HPBar:SetBackdrop(TukuiUnitFrames.Backdrop)
    HPBar:SetBackdropColor(0, 0, 0)
    HPBar:SetBackdropBorderColor(0, 0, 0)

    for i = 1, 5 do
        HPBar[i] = CreateFrame("StatusBar", self:GetName()..'HolyPower'..i, HPBar)
        HPBar[i]:Height(8)
        HPBar[i]:SetStatusBarTexture(PowerTexture)
        HPBar[i]:SetStatusBarColor(0.89, 0.88, 0.06)

        if i == 1 then
            HPBar[i]:Width(50)
            HPBar[i]:Point("LEFT", HPBar, "LEFT", 0, 0)
        else
            HPBar[i]:Width(49)
            HPBar[i]:Point("LEFT", HPBar[i-1], "RIGHT", 1, 0)
        end
    end

    -- Shadow Effect Updates
    HPBar:SetScript("OnShow", function(self)
        TukuiUnitFrames.UpdateShadow(self, 12)
    end)

    HPBar:SetScript("OnHide", function(self)
        TukuiUnitFrames.UpdateShadow(self, 4)
    end)

    -- Totem Bar (Consecration)
    if (C.UnitFrames.TotemBar) then
        T["Colors"].totems[1] = { 218/255, 225/255, 92/255 }

        local TotemBar = self.Totems
        TotemBar:ClearAllPoints()
        TotemBar:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 1)

        TotemBar[1]:ClearAllPoints()
        TotemBar[1]:Width(250)
        TotemBar[1]:SetPoint("LEFT")
        
        TotemBar[2]:Hide()
        TotemBar[3]:Hide()
        TotemBar[4]:Hide()

        TotemBar:SetScript("OnShow", function(self)
            TukuiUnitFrames.UpdateShadow(self, 12)
        end)

        TotemBar:SetScript("OnHide", function(self)
            TukuiUnitFrames.UpdateShadow(self, 4)
        end)
    end

    -- Register
    self.HolyPower = HPBar
end
