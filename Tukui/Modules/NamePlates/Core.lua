local T, C, L = select(2, ...):unpack()

--[[
C["NamePlates"] = {
    ["Enable"] = true,
    ["HealthText"] = false,
    ["Width"] = 150,
    ["Height"] = 6,
    ["CastHeight"] = 4,
    ["Spacing"] = 4,
    ["NonTargetAlpha"] = .5,
    ["Texture"] = "Tukui",
    ["Font"] = "Tukui Outline",
    ["NameTextColor"] = true,
}
--]]

local _G = _G
local unpack = unpack
local Plates = CreateFrame("Frame", nil, WorldFrame)
local Noop = function() end

function Plates:SetName()
    -- QUESTION! NAME IN WHITE OR CLASSCOLORED? :X
    local Text = self:GetText()

    if Text then
        local Class = select(2, UnitClass(self:GetParent().unit))
        
        self:SetText("|cffffffff".. Text .."|r")
    end
end

function Plates:ColorHealth()
    if (self:GetName() and string.find(self:GetName(), "NamePlate")) then
        local r, g, b

        if not UnitIsConnected(self.unit) then
            r, g, b = unpack(T.Colors.disconnected)
        else
            if UnitIsPlayer(self.unit) then
                local Class = select(2, UnitClass(self.unit))
                    
                r, g, b = unpack(T.Colors.class[Class])
            else
                if (UnitIsFriend("player", self.unit)) then
                    r, g, b = unpack(T.Colors.reaction[5])
                else
                    r, g, b = unpack(T.Colors.reaction[1])
                end
            end
        end

        self.healthBar:SetStatusBarColor(r, g, b)
    end
end

function Plates:DisplayCastIcon()
    local Icon = self
    local Tex = Icon:GetTexture()
    local Backdrop = Icon:GetParent()
    
    if Tex then
        if not Backdrop:IsShown() then
            Backdrop:Show()
        end
    else
        if Backdrop:IsShown() then
            Backdrop:Hide()
        end
    end
end

function Plates:SetupPlate(options)
    if self.IsEdited then
        return
    end

    local HealthBar = self.healthBar
    local Highlight = self.selectionHighlight
    local Aggro = self.aggroHighlight
    local CastBar = self.castBar
    local CastBarIcon = self.castBar.Icon
    local Shield = self.castBar.BorderShield
    local Flash = self.castBar.Flash
    local Spark = self.castBar.Spark
    local Name = self.name

    -- HEALTHBAR
    HealthBar:SetStatusBarTexture(C.Medias.Normal)
    HealthBar.background:ClearAllPoints()
    HealthBar.background:SetInside(0, 0)
    HealthBar:CreateShadow()
    HealthBar.border:SetAlpha(0)

    -- CASTBAR
    CastBar:SetStatusBarTexture(C.Medias.Normal)
    CastBar.background:ClearAllPoints()
    CastBar.background:SetInside(0, 0)
    CastBar:CreateShadow()
    
    if CastBar.border then
        CastBar.border:SetAlpha(0)
    end
    
    --CastBar.Icon.SetTexture = function() end
    CastBar.SetStatusBarTexture = function() end
    
    CastBar.IconBackdrop = CreateFrame("Frame", nil, CastBar)
    CastBar.IconBackdrop:SetSize(CastBar.Icon:GetSize())
    CastBar.IconBackdrop:SetPoint("TOPRIGHT", HealthBar, "TOPLEFT", -4, 0)
    CastBar.IconBackdrop:SetBackdrop({bgFile = C.Medias.Blank})
    CastBar.IconBackdrop:SetBackdropColor(unpack(C.Medias.BackdropColor))
    CastBar.IconBackdrop:CreateShadow()
    CastBar.IconBackdrop:SetFrameLevel(CastBar:GetFrameLevel() - 1 or 0)
    
    CastBar.Icon:SetTexCoord(.08, .92, .08, .92)
    CastBar.Icon:SetParent(CastBar.IconBackdrop)
    CastBar.Icon:ClearAllPoints()
    CastBar.Icon:SetAllPoints(CastBar.IconBackdrop)
    CastBar.Icon.ClearAllPoints = Noop
    CastBar.Icon.SetPoint = Noop

    CastBar.Text:SetFont(C.Medias.Font, 9, "OUTLINE")
    
    CastBar.startCastColor.r, CastBar.startCastColor.g, CastBar.startCastColor.b = unpack(Plates.Options.CastBarColors.StartNormal)
    CastBar.startChannelColor.r, CastBar.startChannelColor.g, CastBar.startChannelColor.b = unpack(Plates.Options.CastBarColors.StartChannel)
    CastBar.failedCastColor.r, CastBar.failedCastColor.g, CastBar.failedCastColor.b = unpack(Plates.Options.CastBarColors.Failed)
    CastBar.nonInterruptibleColor.r, CastBar.nonInterruptibleColor.g, CastBar.nonInterruptibleColor.b = unpack(Plates.Options.CastBarColors.NonInterrupt)
    CastBar.finishedCastColor.r, CastBar.finishedCastColor.g, CastBar.finishedCastColor.b = unpack(Plates.Options.CastBarColors.Success)
    
    hooksecurefunc(CastBar.Icon, "SetTexture", Plates.DisplayCastIcon) -- sometime no icons is found, beta bug? so backdrop display update here
    
    -- UNIT NAME
    Name:SetFont(C.Medias.Font, 10, "OUTLINE")
    hooksecurefunc(Name, "Show", Plates.SetName)
    
    -- WILL DO A BETTER VISUAL FOR THIS LATER
    Highlight:Kill()
    Shield:Kill()
    Aggro:Kill()
    Flash:Kill()
    Spark:Kill()
    
    self.IsEdited = true
end

function Plates:Enable()
    local Enabled = C.NamePlates.Enable
    
    if not Enabled then
        return
    end
    
    self:RegisterOptions()
    
    DefaultCompactNamePlateFriendlyFrameOptions = Plates.Options.Friendly
    DefaultCompactNamePlateEnemyFrameOptions = Plates.Options.Enemy
    DefaultCompactNamePlatePlayerFrameOptions = Plates.Options.Player
    DefaultCompactNamePlateFrameSetUpOptions = Plates.Options.Size
    DefaultCompactNamePlatePlayerFrameSetUpOptions = Plates.Options.PlayerSize
    
    if ClassNameplateManaBarFrame then
        ClassNameplateManaBarFrame.Border:SetAlpha(0)
        ClassNameplateManaBarFrame:SetStatusBarTexture(C.Medias.Normal)
        ClassNameplateManaBarFrame.ManaCostPredictionBar:SetTexture(C.Medias.Normal)
        ClassNameplateManaBarFrame:SetBackdrop({bgFile = C.Medias.Blank})
        ClassNameplateManaBarFrame:SetBackdropColor(.2, .2, .2)
        ClassNameplateManaBarFrame:CreateShadow()
    end
    
    hooksecurefunc("DefaultCompactNamePlateFrameSetupInternal", self.SetupPlate)
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", self.ColorHealth)
    
    -- Disable Blizzard rescale
    NamePlateDriverFrame.UpdateNamePlateOptions = function() end
    
    -- Make sure nameplates are always scaled at 1
    SetCVar("NamePlateVerticalScale", "1")
    SetCVar("NamePlateHorizontalScale", "1")
    
    -- Hide the option to rescale, because we will do it from Tukui settings.
    InterfaceOptionsNamesPanelUnitNameplatesMakeLarger:Hide()
end

T["NamePlates"] = Plates
