-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
--[[
	*
	* Variant that synchronizes its action when placed on the highest hierarchy.
	* Useful when the `RunSynchronously` option is disabled but you want a specific action to be executed synchronously.
]]
local SynchronousAction
do
	local super = BaseAction
	SynchronousAction = setmetatable({}, {
		__tostring = function()
			return "SynchronousAction"
		end,
		__index = super,
	})
	SynchronousAction.__index = SynchronousAction
	function SynchronousAction.new(...)
		local self = setmetatable({}, SynchronousAction)
		return self:constructor(...) or self
	end
	function SynchronousAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
	end
	function SynchronousAction:OnConnected()
		local action = transformAction(self.RawAction)
		local connection = ActionConnection:From(action)
		action:SetContext(self.Context)
		connection:Triggered(function()
			self:SetTriggered(true);
			(self.Changed):Fire()
		end)
		connection:Released(function()
			if self.IsActive then
				self:SetTriggered(false)
			end
			(self.Changed):Fire()
		end)
	end
end
local actionMt = SynchronousAction
actionMt.__tostring = function(c)
	return "Synchronous(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	SynchronousAction = SynchronousAction,
}
