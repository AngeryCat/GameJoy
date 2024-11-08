-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local exports = {}
for _k, _v in pairs(TS.import(script, script, "IsInputDown") or {}) do
	exports[_k] = _v
end
exports.TranslateRawAction = TS.import(script, script, "TranslateRawAction").TranslateRawAction
exports.TypeChecks = TS.import(script, script, "TypeChecks")
exports.ModifierKeys = TS.import(script, script, "ModifierKeys").ModifierKeys
exports.WithKeypad = TS.import(script, script, "WithKeypad").WithKeypad
return exports
