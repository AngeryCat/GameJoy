-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local Union = TS.import(script, script.Parent.Parent, "Actions").Union
-- type ModifierEnum =
-- | Enum.KeyCode.LeftShift
-- | Enum.KeyCode.RightShift
-- | Enum.KeyCode.LeftMeta
-- | Enum.KeyCode.RightMeta
-- | Enum.KeyCode.LeftAlt
-- | Enum.KeyCode.RightAlt
-- | Enum.KeyCode.LeftControl
-- | Enum.KeyCode.RightControl
-- | Enum.KeyCode.LeftSuper
-- | Enum.KeyCode.RightSuper;
local unions = {
	Shift = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift },
	Alt = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt },
	Meta = { Enum.KeyCode.LeftMeta, Enum.KeyCode.RightMeta },
	Control = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl },
	Super = { Enum.KeyCode.LeftSuper, Enum.KeyCode.RightSuper },
}
--[[
	*
	* Returns an union of a modifier key that contains both left and right keys.
]]
local function ModifierKeys(key)
	return Union.new(unions[key])
end
return {
	ModifierKeys = ModifierKeys,
}
