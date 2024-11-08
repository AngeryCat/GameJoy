-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
--[[
	*
	* Variant that accepts a callback that can be used to set a condition to your action.
]]
local MiddlewareAction
do
	local super = BaseAction
	MiddlewareAction = setmetatable({}, {
		__tostring = function()
			return "MiddlewareAction"
		end,
		__index = super,
	})
	MiddlewareAction.__index = MiddlewareAction
	function MiddlewareAction.new(...)
		local self = setmetatable({}, MiddlewareAction)
		return self:constructor(...) or self
	end
	function MiddlewareAction:constructor(RawAction, middleware)
		super.constructor(self)
		self.RawAction = RawAction
		self.Middleware = function(self)
			return middleware(self)
		end
	end
	function MiddlewareAction:Middleware(_action)
		return false
	end
	function MiddlewareAction:OnConnected()
		local action = transformAction(self.RawAction)
		local connection = ActionConnection:From(action)
		action:SetContext(self.Context)
		connection:Triggered(function()
			if self:Middleware(self) then
				self:SetTriggered(true)
			end
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
local actionMt = MiddlewareAction
actionMt.__tostring = function(c)
	return "Middleware(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	MiddlewareAction = MiddlewareAction,
}
