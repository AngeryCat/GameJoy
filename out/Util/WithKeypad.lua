-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local Union = TS.import(script, script.Parent.Parent, "Actions").Union
local aliases = TS.import(script, script.Parent.Parent, "Misc", "Aliases")
local keypadIndexDiff = 208
local mappedKeypadEntries = {
	[43] = Enum.KeyCode.KeypadPlus.Value,
	[46] = Enum.KeyCode.KeypadPeriod.Value,
	[61] = Enum.KeyCode.KeypadEquals.Value,
	[45] = Enum.KeyCode.KeypadMinus.Value,
}
--[[
	*
	* Returns an union containing a number key and its numpad equivalent.
]]
local function WithKeypad(entry)
	local value = if typeof(entry) == "EnumItem" then entry.Value elseif type(entry) == "string" then if aliases[entry] ~= nil then Enum.KeyCode[aliases[entry]].Value else Enum.KeyCode[entry].Value elseif type(entry) == "number" then entry else entry
	local v = value
	local keypadValue
	if v >= 48 and v <= 57 then
		keypadValue = v + keypadIndexDiff
	else
		keypadValue = mappedKeypadEntries[value]
	end
	return Union.new({ entry, keypadValue })
end
return {
	WithKeypad = WithKeypad,
}
