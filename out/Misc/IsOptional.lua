-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
local function isOptional(action)
	return t.actionEntryIs(action, "OptionalAction")
end
return {
	isOptional = isOptional,
}
