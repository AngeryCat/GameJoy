-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local IS = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local TranslateRawAction = TS.import(script, script.Parent, "TranslateRawAction").TranslateRawAction
local t = TS.import(script, script.Parent, "TypeChecks")
local function check(rawAction)
	local input = TranslateRawAction(rawAction)
	if t.isMouseButton(input) then
		return IS:IsMouseButtonPressed(input)
	elseif t.isKeyCode(input) then
		return IS:IsKeyDown(input)
	else
		return false
	end
end
--[[
	*
	* Checks if all the specified inputs are being pressed.
]]
local function IsInputDown(input)
	local _exp = (if t.isRawActionArray(input) then input else { input })
	local _arg0 = function(x)
		return check(x)
	end
	-- ▼ ReadonlyArray.every ▼
	local _result = true
	for _k, _v in ipairs(_exp) do
		if not _arg0(_v, _k - 1, _exp) then
			_result = false
			break
		end
	end
	-- ▲ ReadonlyArray.every ▲
	return _result
end
--[[
	*
	* Checks if any of the specified inputs is being pressed.
]]
local function IsAnyInputDown(inputs)
	local _arg0 = function(x)
		return check(x)
	end
	-- ▼ ReadonlyArray.some ▼
	local _result = false
	for _k, _v in ipairs(inputs) do
		if _arg0(_v, _k - 1, inputs) then
			_result = true
			break
		end
	end
	-- ▲ ReadonlyArray.some ▲
	return _result
end
return {
	IsInputDown = IsInputDown,
	IsAnyInputDown = IsAnyInputDown,
}
