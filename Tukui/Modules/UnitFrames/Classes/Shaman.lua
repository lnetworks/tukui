local T, C, L = select(2, ...):unpack()

local TukuiUnitFrames = T["UnitFrames"]
local Class = select(2, UnitClass("player"))

if (Class ~= "SHAMAN") then
    return
end

TukuiUnitFrames.AddClassFeatures["SHAMAN"] = function(self)
    if (C.UnitFrames.TotemBar) then
        -- Default layout of Totems match Shaman class.
        local Bar = self.Totems

        for i = 1, MAX_TOTEMS do
            Bar[i].Icon = Bar[i]:CreateTexture(nil, "BORDER")
            Bar[i].Icon:SetAllPoints()
            Bar[i].Icon:SetAlpha(1)
            Bar[i].Icon:Size(Bar[i]:GetWidth(), 8)
            Bar[i].Icon:SetTexCoord(0.05, 0.95, 0.5, 0.7)
        end
    end
end
