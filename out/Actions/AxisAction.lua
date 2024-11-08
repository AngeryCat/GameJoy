-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local Action = TS.import(script, script.Parent, "Action").Action
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
--[[
	*
	* Variant that provides support for inputs that have a continuous range.
	* The action is triggered everytime the input is changed.
]]
local AxisAction
do
	local super = BaseAction
	AxisAction = setmetatable({}, {
		__tostring = function()
			return "AxisAction"
		end,
		__index = super,
	})
	AxisAction.__index = AxisAction
	function AxisAction.new(...)
		local self = setmetatable({}, AxisAction)
		return self:constructor(...) or self
	end
	function AxisAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
		self.Delta = Vector3.new()
		self.Position = Vector3.new()
		self.KeyCode = Enum.KeyCode.Unknown
	end
	function AxisAction:OnConnected()
		local action = Action.new(self.RawAction)
		local connection = ActionConnection:From(action)
		local thisConnection = ActionConnection:From(self)
		action:SetContext(self.Context)
		connection:Changed(function()
			return (self.Changed):Fire()
		end)
		thisConnection:Changed(function()
			self:SetTriggered(true)
			self:SetTriggered(false, true)
		end)
		thisConnection:Destroyed(function()
			action:Destroy()
		end)
	end
end
local actionMt = AxisAction
actionMt.__tostring = function(c)
	local _condition = c:GetContentString()[1]
	if _condition == nil then
		_condition = ""
	end
	return "Axis(" .. (_condition .. ")")
end
return {
	AxisAction = AxisAction,
}
