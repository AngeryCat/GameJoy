-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local aliases = TS.import(script, script.Parent.Parent, "Misc", "Aliases")
--[[
	*
	* Object that holds information about inputs that can be performed by the player while in a context.
]]
local Action
do
	local super = BaseAction
	Action = setmetatable({}, {
		__tostring = function()
			return "Action"
		end,
		__index = super,
	})
	Action.__index = Action
	function Action.new(...)
		local self = setmetatable({}, Action)
		return self:constructor(...) or self
	end
	function Action:constructor(RawAction, options)
		if options == nil then
			options = {}
		end
		super.constructor(self)
		self.RawAction = RawAction
		self.options = options
		self.Began = Signal.new()
		self.Ended = Signal.new()
		self.Cancelled = Signal.new()
		local alias = aliases[RawAction]
		if alias then
			self.RawAction = alias
		end
	end
	function Action:OnConnected()
		local _binding = self.options
		local Repeat = _binding.Repeat
		if Repeat == nil then
			Repeat = 1
		end
		local Timing = _binding.Timing
		if Timing == nil then
			Timing = 0.3
		end
		local repeatTimes = math.max(1, Repeat)
		local timing = math.max(0, Timing)
		local connection = ActionConnection:From(self)
		local newInputSignal = Signal.new()
		local cancelled = true
		local timesTriggered = 0
		connection:Began(function()
			cancelled = true
			timesTriggered += 1
			newInputSignal:Fire();
			(self.Changed):Fire()
			local _exp = TS.Promise.new(function(resolve)
				if repeatTimes > 1 then
					newInputSignal:Wait()
				end
				resolve(timesTriggered >= repeatTimes)
			end):timeout(timing)
			local _arg0 = function(isCompleted)
				if isCompleted then
					timesTriggered = 0
					cancelled = false
					self:SetTriggered(true)
				end
			end
			local _arg1 = function()
				timesTriggered = 0
				if cancelled then
					(self.Cancelled):Fire()
					self:SetTriggered(false)
				end
			end
			_exp:andThen(_arg0, _arg1)
		end)
		connection:Ended(function()
			if self.IsActive and not cancelled then
				self:SetTriggered(false)
			end
			if repeatTimes == 1 then
				(self.Released):Fire(false)
			end
			(self.Changed):Fire()
		end)
		connection:Destroyed(function()
			return newInputSignal:Destroy()
		end)
	end
end
local actionMt = Action
actionMt.__tostring = function(c)
	local _condition = c:GetContentString()[1]
	if _condition == nil then
		_condition = ""
	end
	return "Action(" .. (_condition .. ")")
end
return {
	Action = Action,
}
