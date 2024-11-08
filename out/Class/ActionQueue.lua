-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local _rust_classes = TS.import(script, TS.getModule(script, "@rbxts", "rust-classes").out)
local Option = _rust_classes.Option
local Vec = _rust_classes.Vec
local Bin = TS.import(script, TS.getModule(script, "@rbxts", "bin").out).Bin
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
local _binding = Option
local Some = _binding.some
local ActionQueue
do
	ActionQueue = setmetatable({}, {
		__tostring = function()
			return "ActionQueue"
		end,
	})
	ActionQueue.__index = ActionQueue
	function ActionQueue.new(...)
		local self = setmetatable({}, ActionQueue)
		return self:constructor(...) or self
	end
	function ActionQueue:constructor()
		self.Entries = Vec:vec()
		self.updated = Signal.new()
		self.updated:Connect(function()
			self.Entries:first():andWith(function(entry)
				if not entry.isExecuting then
					entry.isExecuting = true
					entry.executable()
				end
				return Some({})
			end)
		end)
	end
	function ActionQueue:Reject(_param)
		local bin = _param.bin
		local action = _param.action
		bin:destroy()
		self:Remove(action);
		(action.Rejected):Fire()
	end
	function ActionQueue:Add(action, listener)
		local _binding_1 = self
		local Entries = _binding_1.Entries
		local updated = _binding_1.updated
		local bin = Bin.new()
		local executable = function()
			local execute = TS.Promise.try(TS.async(function()
				local result = listener()
				if TS.Promise.is(result) then
					TS.await(result)
				end
				Entries:remove(0);
				(action.Resolved):Fire()
			end))
			execute:finally(function()
				bin:destroy()
				updated:Fire()
			end)
			return execute
		end
		local newEntry = {
			action = action,
			bin = bin,
			executable = executable,
			isExecuting = false,
		}
		Entries:push(newEntry)
		local i = Entries:len()
		if i > 1 then
			if t.isCancellableAction(action) then
				bin:add(action.Cancelled:Connect(function()
					return self:Reject(newEntry)
				end))
			end
			bin:add(action.Released:Connect(function()
				return self:Reject(newEntry)
			end))
		else
			updated:Fire()
		end
	end
	function ActionQueue:Remove(action)
		local _binding_1 = self
		local Entries = _binding_1.Entries
		local updated = _binding_1.updated
		Entries:iter():enumerate():find(function(_param)
			local _binding_2 = _param[2]
			local x = _binding_2.action
			return action == x
		end):andWith(function(_param)
			local i = _param[1]
			Entries:remove(i)
			updated:Fire()
			return Some({})
		end)
	end
end
return {
	ActionQueue = ActionQueue,
}
