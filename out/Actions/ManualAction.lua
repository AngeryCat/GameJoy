-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
--[[
	*
	* Variant that is used to act as a placeholder for manual triggering.
]]
local ManualAction
do
	local super = BaseAction
	ManualAction = setmetatable({}, {
		__tostring = function()
			return "ManualAction"
		end,
		__index = super,
	})
	ManualAction.__index = ManualAction
	function ManualAction.new(...)
		local self = setmetatable({}, ManualAction)
		return self:constructor(...) or self
	end
	function ManualAction:constructor()
		super.constructor(self)
		self.RawAction = {}
	end
	function ManualAction:OnConnected()
	end
	function ManualAction:Trigger(...)
		local params = { ... }
		if not self.Context then
			return nil
		end
		task.defer(function()
			local _fn = (self.Triggered)
			local _result = self.Context
			if _result ~= nil then
				_result = _result.Options.Process
			end
			return _fn:Fire(_result, unpack(params))
		end)
	end
end
local actionMt = ManualAction
actionMt.__tostring = function()
	return "Manual"
end
return {
	ManualAction = ManualAction,
}
