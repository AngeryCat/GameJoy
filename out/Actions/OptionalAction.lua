-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
--[[
	*
	* Variant that is used to act as a "ghost" action when placed inside objects that accepts multiple entries.
	* Its parent action can trigger without the need of the action being active, and will trigger again once the action activates.
]]
local OptionalAction
do
	local super = BaseAction
	OptionalAction = setmetatable({}, {
		__tostring = function()
			return "OptionalAction"
		end,
		__index = super,
	})
	OptionalAction.__index = OptionalAction
	function OptionalAction.new(...)
		local self = setmetatable({}, OptionalAction)
		return self:constructor(...) or self
	end
	function OptionalAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
	end
	function OptionalAction:OnConnected()
		local action = transformAction(self.RawAction)
		local connection = ActionConnection:From(action)
		action:SetContext(self.Context)
		connection:Triggered(function()
			self:SetTriggered(true);
			(self.Changed):Fire()
		end)
		connection:Released(function()
			self:SetTriggered(false);
			(self.Changed):Fire()
		end)
		ActionConnection:From(self):Destroyed(function()
			action:Destroy()
		end)
	end
end
local actionMt = OptionalAction
actionMt.__tostring = function(c)
	return "Optional(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	OptionalAction = OptionalAction,
}
