if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local parent, ns = ...
local oUF = ns.oUF

oUF.colors.runes = {
    ["READY"] = {0.31, 0.45, 0.63},
    ["CD"] = {0.7, 0.7, 0.7},
}

local OnUpdate = function(self, elapsed)
    local duration = self.duration + elapsed
    local cd = self.max - duration

    if(duration >= self.max) then
        self:SetStatusBarColor(unpack(oUF.colors.runes["READY"]))

        return self:SetScript("OnUpdate", nil)
    else
        self:SetStatusBarColor(unpack(oUF.colors.runes["CD"]))

        self.duration = duration

        return self:SetValue(cd)
    end
end

local UpdateRune = function(self, event, rid)
    local runes = self.Runes
    local rune = runes[rid]

    if(not rune) then return end

    if(UnitHasVehicleUI'player') then
        return rune:Hide()
    else
        rune:Show()
    end

    local start, duration, runeReady = GetRuneCooldown(rid)
    if (runeReady) then
        rune:SetMinMaxValues(0, 1)
        rune:SetValue(1)
        rune:SetScript("OnUpdate", nil)
    elseif start and duration then
        rune.duration = GetTime() - start
        rune.max = duration
        rune:SetMinMaxValues(1, duration)
        rune:SetScript("OnUpdate", OnUpdate)
    end

    if(runes.PostUpdateRune) then
        return runes:PostUpdateRune(rune, rid, start, duration, runeReady)
    end
end

local Path = function(self, ...)
    return (self.Runes.Override or UpdateRune) (self, ...)
end

local Update = function(self, event)
    for i=1, 6 do
        Path(self, event, i)
    end
end

local ForceUpdate = function(element)
    return Update(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
    local runes = self.Runes
    if(runes and unit == 'player') then
        runes.__owner = self
        runes.ForceUpdate = ForceUpdate
        
        for i=1, 6 do
            local rune = runes[i]
            
            if(rune:IsObjectType'StatusBar' and not rune:GetStatusBarTexture()) then
                rune:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
            end
        end
        
        self:RegisterEvent("RUNE_POWER_UPDATE", UpdateRune, true)
        
        -- oUF leaves the vehicle events registered on the player frame, so
        -- buffs and such are correctly updated when entering/exiting vehicles.
        --
        -- This however makes the code also show/hide the RuneFrame.
        RuneFrame.Show = RuneFrame.Hide
        RuneFrame:Hide()
        
        return true
    end
end

local Disable = function(self)
    RuneFrame.Show = nil
    RuneFrame:Show()
    
    self:UnregisterEvent("RUNE_POWER_UPDATE", UpdateRune)
end

oUF:AddElement("Runes", Update, Enable, Disable)