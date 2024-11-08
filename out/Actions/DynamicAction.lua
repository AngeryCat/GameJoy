-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
--[[
	*
	* Variant that accepts any action as a parameter and can be updated.
	*
	* It has an `Update` method and a `.Updated` signal that fires whenever it's updated.
]]
local DynamicAction
do
	local super = BaseAction
	DynamicAction = setmetatable({}, {
		__tostring = function()
			return "DynamicAction"
		end,
		__index = super,
	})
	DynamicAction.__index = DynamicAction
	function DynamicAction.new(...)
		local self = setmetatable({}, DynamicAction)
		return self:constructor(...) or self
	end
	function DynamicAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
		self.Updated = Signal.new()
		ActionConnection:From(self):Destroyed(function()
			local _result = self.currentConnection
			if _result ~= nil then
				_result = _result.Action:Destroy()
			end
		end)
	end
	function DynamicAction:ConnectAction(newAction)
		local action = transformAction(newAction)
		self.RawAction = action.RawAction
		self:LoadContent()
		if self.Context then
			local connection = ActionConnection:From(action)
			action:SetContext(self.Context)
			connection:Triggered(function()
				self:SetTriggered(true);
				(self.Changed):Fire()
			end)
			connection:Released(function()
				if self.IsActive then
					self:SetTriggered(false);
					(self.Changed):Fire()
				end
			end)
			self.currentConnection = connection
		end
	end
	function DynamicAction:OnConnected()
		self:ConnectAction(self.RawAction)
	end
	function DynamicAction:Update(newAction)
		if not t.isValidActionEntry(newAction) then
			error(debug.traceback("Invalid action entry."))
		end
		self:SetTriggered(false)
		local _result = self.currentConnection
		if _result ~= nil then
			_result:Destroy()
		end
		self:ConnectAction(newAction)
		self.Updated:Fire()
	end
end
local actionMt = DynamicAction
actionMt.__tostring = function(c)
	return "Dynamic(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	DynamicAction = DynamicAction,
}
