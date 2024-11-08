-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local aliases = TS.import(script, script.Parent.Parent, "Misc", "Aliases")
local actions = { "Action", "AxisAction", "CompositeAction", "DynamicAction", "ManualAction", "MiddlewareAction", "OptionalAction", "SequenceAction", "SynchronousAction", "UnionAction", "UniqueAction" }
local axisActionEntries = { Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseWheel, Enum.UserInputType.Touch, Enum.UserInputType.Gyro, Enum.UserInputType.Accelerometer, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4, Enum.UserInputType.Gamepad5, Enum.UserInputType.Gamepad6, Enum.UserInputType.Gamepad7, Enum.UserInputType.Gamepad8, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 }
local mouseButtonActionEntries = { Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3 }
local unusedKeys = { Enum.KeyCode.Unknown, Enum.KeyCode.World0, Enum.KeyCode.World1, Enum.KeyCode.World2, Enum.KeyCode.World3, Enum.KeyCode.World4, Enum.KeyCode.World5, Enum.KeyCode.World6, Enum.KeyCode.World7, Enum.KeyCode.World8, Enum.KeyCode.World9, Enum.KeyCode.World10, Enum.KeyCode.World11, Enum.KeyCode.World12, Enum.KeyCode.World13, Enum.KeyCode.World14, Enum.KeyCode.World15, Enum.KeyCode.World16, Enum.KeyCode.World17, Enum.KeyCode.World18, Enum.KeyCode.World19, Enum.KeyCode.World20, Enum.KeyCode.World21, Enum.KeyCode.World22, Enum.KeyCode.World23, Enum.KeyCode.World24, Enum.KeyCode.World25, Enum.KeyCode.World26, Enum.KeyCode.World27, Enum.KeyCode.World28, Enum.KeyCode.World29, Enum.KeyCode.World30, Enum.KeyCode.World31, Enum.KeyCode.World32, Enum.KeyCode.World33, Enum.KeyCode.World34, Enum.KeyCode.World35, Enum.KeyCode.World36, Enum.KeyCode.World37, Enum.KeyCode.World38, Enum.KeyCode.World39, Enum.KeyCode.World40, Enum.KeyCode.World41, Enum.KeyCode.World42, Enum.KeyCode.World43, Enum.KeyCode.World44, Enum.KeyCode.World45, Enum.KeyCode.World46, Enum.KeyCode.World47, Enum.KeyCode.World48, Enum.KeyCode.World49, Enum.KeyCode.World50, Enum.KeyCode.World51, Enum.KeyCode.World52, Enum.KeyCode.World53, Enum.KeyCode.World54, Enum.KeyCode.World55, Enum.KeyCode.World56, Enum.KeyCode.World57, Enum.KeyCode.World58, Enum.KeyCode.World59, Enum.KeyCode.World60, Enum.KeyCode.World61, Enum.KeyCode.World62, Enum.KeyCode.World63, Enum.KeyCode.World64, Enum.KeyCode.World65, Enum.KeyCode.World66, Enum.KeyCode.World67, Enum.KeyCode.World68, Enum.KeyCode.World69, Enum.KeyCode.World70, Enum.KeyCode.World71, Enum.KeyCode.World72, Enum.KeyCode.World73, Enum.KeyCode.World74, Enum.KeyCode.World75, Enum.KeyCode.World76, Enum.KeyCode.World77, Enum.KeyCode.World78, Enum.KeyCode.World79, Enum.KeyCode.World80, Enum.KeyCode.World81, Enum.KeyCode.World82, Enum.KeyCode.World83, Enum.KeyCode.World84, Enum.KeyCode.World85, Enum.KeyCode.World86, Enum.KeyCode.World87, Enum.KeyCode.World88, Enum.KeyCode.World89, Enum.KeyCode.World90, Enum.KeyCode.World91, Enum.KeyCode.World92, Enum.KeyCode.World93, Enum.KeyCode.World94, Enum.KeyCode.World95 }
local classIsOfType = function(value, classType)
	return type(value) == "table" and tostring((getmetatable(value))) == classType
end
--[[
	*
	* Checks if the action entry matches a KeyCode and/or UserInputType member.
]]
local isActionEqualTo = function(entry, key, input)
	local _condition = (typeof(entry) == "EnumItem" and key == entry) or ((type(entry) == "string" and key.Name == entry) or ((type(entry) == "number" and key.Value == entry) or (typeof(entry) == "EnumItem" and input == entry)))
	if not _condition then
		local _condition_1 = type(entry) == "string"
		if _condition_1 then
			local _result = input
			if _result ~= nil then
				_result = _result.Name
			end
			_condition_1 = _result == entry
		end
		_condition = _condition_1
		if not _condition then
			local _condition_2 = type(entry) == "number"
			if _condition_2 then
				local _result = input
				if _result ~= nil then
					_result = _result.Value
				end
				_condition_2 = _result == entry
			end
			_condition = _condition_2
		end
	end
	return _condition
end
--[[
	*
	* Checks if the value is an action object.
]]
local isAction = function(value)
	local _arg0 = function(actionType)
		return classIsOfType(value, actionType)
	end
	-- ▼ ReadonlyArray.some ▼
	local _result = false
	for _k, _v in ipairs(actions) do
		if _arg0(_v, _k - 1, actions) then
			_result = true
			break
		end
	end
	-- ▲ ReadonlyArray.some ▲
	return _result
end
--[[
	*
	* Checks if the value is an array of action objects.
]]
local isActionArray = t.array(isAction)
local EnumAlias = function(rEnum)
	return function(value)
		local _exp = rEnum:GetEnumItems()
		local _arg0 = function(item)
			return item.Name == value or (item.Value == value or aliases[value] == item.Name)
		end
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		for _k, _v in ipairs(_exp) do
			if _arg0(_v, _k - 1, _exp) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		return _result
	end
end
--[[
	*
	* Checks if the value is a raw action.
]]
local isRawAction = t.union(EnumAlias(Enum.KeyCode), EnumAlias(Enum.UserInputType), t.enum(Enum.KeyCode), t.enum(Enum.UserInputType))
--[[
	*
	* Checks if the value is an array of raw actions.
]]
local isRawActionArray = t.array(isRawAction)
--[[
	*
	* Checks if the value is action-like.
]]
local isActionLike = t.union(isAction, isRawAction, isRawActionArray)
--[[
	*
	* Checks if the value is an array of action-like values.
]]
local isActionLikeArray = t.array(isActionLike)
--[[
	*
	* Checks if the value is a valid action entry.
]]
local isValidActionEntry = t.union(isActionLike, isActionLikeArray)
--[[
	*
	* Checks if an action object matches a specified variant.
]]
local actionEntryIs = function(value, actionType)
	return classIsOfType(value, actionType)
end
--[[
	*
	* Checks if the value is an axis action entry.
]]
local isAxisActionEntry = function(value)
	local _arg0 = function(e)
		return (typeof(value) == "EnumItem" and e == value) or ((type(value) == "string" and e.Name == value) or (type(value) == "number" and e.Value == value))
	end
	-- ▼ ReadonlyArray.some ▼
	local _result = false
	for _k, _v in ipairs(axisActionEntries) do
		if _arg0(_v, _k - 1, axisActionEntries) then
			_result = true
			break
		end
	end
	-- ▲ ReadonlyArray.some ▲
	return _result
end
--[[
	*
	* Checks if the value is a valid MouseButton entry.
]]
local isMouseButton = function(value)
	local _arg0 = function(e)
		return (typeof(value) == "EnumItem" and e == value) or ((type(value) == "string" and e.Name == value) or (type(value) == "number" and e.Value == value))
	end
	-- ▼ ReadonlyArray.some ▼
	local _result = false
	for _k, _v in ipairs(mouseButtonActionEntries) do
		if _arg0(_v, _k - 1, mouseButtonActionEntries) then
			_result = true
			break
		end
	end
	-- ▲ ReadonlyArray.some ▲
	return _result
end
--[[
	*
	* Checks if the value is a valid KeyCode entry.
]]
local isKeyCode = function(value)
	local _exp = Enum.KeyCode:GetEnumItems()
	local _arg0 = function(e)
		local _arg0_1 = function(x)
			return x == e
		end
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		for _k, _v in ipairs(unusedKeys) do
			if _arg0_1(_v, _k - 1, unusedKeys) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		return not _result
	end
	-- ▼ ReadonlyArray.filter ▼
	local _newValue = {}
	local _length = 0
	for _k, _v in ipairs(_exp) do
		if _arg0(_v, _k - 1, _exp) == true then
			_length += 1
			_newValue[_length] = _v
		end
	end
	-- ▲ ReadonlyArray.filter ▲
	local _arg0_1 = function(e)
		return value == e
	end
	-- ▼ ReadonlyArray.some ▼
	local _result = false
	for _k, _v in ipairs(_newValue) do
		if _arg0_1(_v, _k - 1, _newValue) then
			_result = true
			break
		end
	end
	-- ▲ ReadonlyArray.some ▲
	return _result
end
local isCancellableAction = function(value)
	return actionEntryIs(value, "Action") or actionEntryIs(value, "SequenceAction")
end
return {
	isActionEqualTo = isActionEqualTo,
	isAction = isAction,
	isActionArray = isActionArray,
	EnumAlias = EnumAlias,
	isRawAction = isRawAction,
	isRawActionArray = isRawActionArray,
	isActionLike = isActionLike,
	isActionLikeArray = isActionLikeArray,
	isValidActionEntry = isValidActionEntry,
	actionEntryIs = actionEntryIs,
	isAxisActionEntry = isAxisActionEntry,
	isMouseButton = isMouseButton,
	isKeyCode = isKeyCode,
	isCancellableAction = isCancellableAction,
}
