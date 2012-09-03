local T, C, L = unpack(Tukui)
if C.announcements.interrupts ~= true then return end

----------------------------------------------------------------------------------------
--	Announce your interrupts(by Elv22)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function(self, _, ...)
	local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = ...
	if not (event == "SPELL_INTERRUPT" and sourceGUID == UnitGUID("player")) then return end

	if IsInRaid() then
		SendChatMessage(INTERRUPTED.." "..destName..": "..GetSpellLink(spellID), "RAID")
	elseif IsInGroup() then
		SendChatMessage(INTERRUPTED.." "..destName..": "..GetSpellLink(spellID), "PARTY")
	else
		SendChatMessage(INTERRUPTED.." "..destName..": "..GetSpellLink(spellID), "SAY")
	end
end)