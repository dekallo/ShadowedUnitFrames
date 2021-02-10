local Paladin = {}
ShadowUF:RegisterModule(Paladin, "paladinBar", ShadowUF.L["Paladin mana bar"], true, "PALADIN", {2, SPEC_PALADIN_RETRIBUTION})

function Paladin:OnEnable(frame)
	frame.paladinBar = frame.paladinBar or ShadowUF.Units:CreateBar(frame)
	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "PowerChanged")

	frame:RegisterUpdateFunc(self, "PowerChanged")
	frame:RegisterUpdateFunc(self, "Update")
end

function Paladin:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Paladin:OnLayoutApplied(frame)
	if( not frame.visibility.paladinBar ) then return end

	local color = ShadowUF.db.profile.powerColors.MANA
	frame:SetBarColor("paladinBar", color.r, color.g, color.b)
end

function Paladin:PowerChanged(frame)
	local visible = not frame.inVehicle
	local type = visible and "RegisterUnitEvent" or "UnregisterSingleEvent"

	frame[type](frame, "UNIT_POWER_FREQUENT", self, "Update")
	frame[type](frame, "UNIT_MAXPOWER", self, "Update")
	ShadowUF.Layout:SetBarVisibility(frame, "paladinBar", visible)

	if( visible ) then self:Update(frame) end
end

function Paladin:Update(frame, event, unit, powerType)
	if( powerType and powerType ~= "MANA" ) then return end
	frame.paladinBar:SetMinMaxValues(0, UnitPowerMax(frame.unit, Enum.PowerType.Mana))
	frame.paladinBar:SetValue(UnitIsDeadOrGhost(frame.unit) and 0 or not UnitIsConnected(frame.unit) and 0 or UnitPower(frame.unit, Enum.PowerType.Mana))

	-- disable regular mana bar
	ShadowUF.Layout:SetBarVisibility(frame, "powerBar", false)
end
