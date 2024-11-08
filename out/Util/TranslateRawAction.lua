-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local aliases = TS.import(script, script.Parent.Parent, "Misc", "Aliases")
local check = function(e, rawAction)
	return e.Name == rawAction or (e.Value == rawAction or e == rawAction)
end
--[[
	*
	* Translates a raw action into its enum item equivalent.
]]
local function TranslateRawAction(rawAction)
	local _condition = aliases[rawAction]
	if _condition == nil then
		_condition = rawAction
	end
	local entry = _condition
	local _exp = Enum.UserInputType:GetEnumItems()
	local _arg0 = function(e)
		return check(e, entry)
	end
	-- ▼ ReadonlyArray.find ▼
	local _result = nil
	for _i, _v in ipairs(_exp) do
		if _arg0(_v, _i - 1, _exp) == true then
			_result = _v
			break
		end
	end
	-- ▲ ReadonlyArray.find ▲
	local _condition_1 = _result
	if not _condition_1 then
		local _exp_1 = Enum.KeyCode:GetEnumItems()
		local _arg0_1 = function(e)
			return check(e, entry)
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_1 = nil
		for _i, _v in ipairs(_exp_1) do
			if _arg0_1(_v, _i - 1, _exp_1) == true then
				_result_1 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		_condition_1 = _result_1
	end
	return _condition_1
end
return {
	TranslateRawAction = TranslateRawAction,
}
