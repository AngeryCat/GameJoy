-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local IS = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local Bin = TS.import(script, TS.getModule(script, "@rbxts", "bin").out).Bin
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
local function checkInputs(action, keyCode, inputType, processed, callback)
	local context = action.Context
	if context then
		local _binding = context.Options
		local Process = _binding.Process
		local rawAction = action.RawAction
		print(processed)
		if t.isActionEqualTo(rawAction, keyCode, inputType) and (Process == nil or Process == processed) then
			callback(processed)
		end
	end
end
local ActionConnection
do
	ActionConnection = setmetatable({}, {
		__tostring = function()
			return "ActionConnection"
		end,
	})
	ActionConnection.__index = ActionConnection
	function ActionConnection.new(...)
		local self = setmetatable({}, ActionConnection)
		return self:constructor(...) or self
	end
	function ActionConnection:constructor(Action)
		self.Action = Action
		self.bin = Bin.new()
		self:Destroyed(function()
			return self.bin:destroy()
		end)
	end
	function ActionConnection:Connect(signal, callback)
		self.bin:add(signal:Connect(callback))
	end
	function ActionConnection:From(action)
		return ActionConnection.new(action)
	end
	function ActionConnection:SendInputRequest(keyCode, inputType, processed, callback)
		checkInputs(self.Action, keyCode, inputType, processed, callback)
	end
	function ActionConnection:Began(callback)
		if t.actionEntryIs(self.Action, "Action") then
			self:Connect(self.Action.Began, callback)
			self.bin:add(IS.InputBegan:Connect(function(_param, processed)
				local KeyCode = _param.KeyCode
				local UserInputType = _param.UserInputType
				return self:SendInputRequest(KeyCode, UserInputType, processed, callback)
			end))
		end
	end
	function ActionConnection:Ended(callback)
		if t.actionEntryIs(self.Action, "Action") then
			self:Connect(self.Action.Ended, callback)
			self.bin:add(IS.InputEnded:Connect(function(_param, processed)
				local KeyCode = _param.KeyCode
				local UserInputType = _param.UserInputType
				return self:SendInputRequest(KeyCode, UserInputType, processed, callback)
			end))
		end
	end
	function ActionConnection:Destroyed(callback)
		self:Connect(self.Action.Destroyed, callback)
	end
	function ActionConnection:Triggered(callback)
		self:Connect(self.Action.Triggered, callback)
	end
	function ActionConnection:Released(callback)
		self:Connect(self.Action.Released, callback)
	end
	function ActionConnection:Changed(callback)
		local _binding = self
		local Action = _binding.Action
		self:Connect(Action.Changed, callback)
		if t.actionEntryIs(Action, "AxisAction") then
			self.bin:add(IS.InputChanged:Connect(function(_param, processed)
				local Delta = _param.Delta
				local KeyCode = _param.KeyCode
				local UserInputType = _param.UserInputType
				local Position = _param.Position
				if t.isActionEqualTo(Action.RawAction, KeyCode, UserInputType) then
					Action.Delta = Delta
					Action.Position = Position
					Action.KeyCode = KeyCode
					self:SendInputRequest(KeyCode, UserInputType, processed, callback)
				end
			end))
		end
	end
	function ActionConnection:Cancelled(callback)
		if t.isCancellableAction(self.Action) then
			self:Connect(self.Action.Cancelled, callback)
		end
	end
	function ActionConnection:Destroy()
		self.Action:Destroy()
	end
end
return {
	ActionConnection = ActionConnection,
}
