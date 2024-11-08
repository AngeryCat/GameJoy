-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local _rust_classes = TS.import(script, TS.getModule(script, "@rbxts", "rust-classes").out)
local HashMap = _rust_classes.HashMap
local Option = _rust_classes.Option
local Result = _rust_classes.Result
local Vec = _rust_classes.Vec
local ActionQueue = TS.import(script, script.Parent, "ActionQueue").ActionQueue
local ActionConnection = TS.import(script, script.Parent, "ActionConnection").ActionConnection
local _Actions = TS.import(script, script.Parent.Parent, "Actions")
local Manual = _Actions.Manual
local Sync = _Actions.Sync
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
local _binding = Result
local Ok = _binding.ok
local _binding_1 = Option
local Some = _binding_1.some
-- eslint-disable prettier/prettier
local ACTION_UNWRAP_ERROR = "An error occurred while trying to unwrap action."
local CHOSEN_ACTION_UNWRAP_ERROR = "Error while unwraping the chosen action. Vec may be empty."
local ACTION_REMOVAL_WARNING = debug.traceback("The specified action is not bound to this context.")
local SIGNAL_NO_CONNECT_METHOD_ERROR = debug.traceback("Signal wrapper doesn't contain a valid connect method.")
local SIGNAL_CONNECTION_NO_DISCONNECT_METHOD_ERROR = debug.traceback("Connection doesn't contain a valid disconnect method.")
local EVENT_NOT_BOUND_WARNING = function(event)
	return debug.traceback('"' .. (event .. '" event is not bound to this context.'))
end
-- eslint-enable prettier/prettier
local defaultOptions = {
	ActionGhosting = 0,
	OnBefore = function()
		return true
	end,
	RunSynchronously = false,
}
local rustWarn = function(...)
	local params = { ... }
	warn(unpack(params))
	return {}
end
--[[
	*
	* Object responsible for storing and managing bound actions.
	*
	* `ActionGhosting`:
	* Limits the amount of actions that can trigger if those have any raw action in common. If set to 0, this property will be ignored.
	*
	* `OnBefore`:
	* Applies a check on every completed action. If the check fails, the action won't be triggered.
	*
	* `Process`:
	* Specifies that the action should trigger if gameProcessedEvent matches the setting. If nothing is passed, the action will trigger independently.
	*
	* `RunSynchronously`:
	* Specifies if the actions are going to run synchronously or not.
	* This will ignore the action queue and resolve the action instantly.
]]
local Context
do
	Context = setmetatable({}, {
		__tostring = function()
			return "Context"
		end,
	})
	Context.__index = Context
	function Context.new(...)
		local self = setmetatable({}, Context)
		return self:constructor(...) or self
	end
	function Context:constructor(options)
		if not RunService:IsClient() then
			error(debug.traceback(tostring((getmetatable(self))) .. " can only be instantied on the client."))
		end
		local _object = {}
		for _k, _v in pairs(defaultOptions) do
			_object[_k] = _v
		end
		if type(options) == "table" then
			for _k, _v in pairs(options) do
				_object[_k] = _v
			end
		end
		self.Options = _object
		self.actions = HashMap:empty()
		self.events = HashMap:empty()
		self.pending = Vec:vec()
		self.isPending = false
		self.queue = ActionQueue.new()
	end
	function Context:ConnectAction(action)
		local _binding_2 = self
		local actions = _binding_2.actions
		local pending = _binding_2.pending
		local queue = _binding_2.queue
		local _binding_3 = self.Options
		local isSync = _binding_3.RunSynchronously
		local OnBefore = _binding_3.OnBefore
		local ghostingCap = _binding_3.ActionGhosting
		action:SetContext(self)
		local connection = ActionConnection:From(action)
		connection:Triggered(function(_, ...)
			local args = { ... }
			local listener = function()
				return actions:get(action):expect(ACTION_UNWRAP_ERROR)(unpack(args))
			end
			if OnBefore() == true then
				pending:push({ action, listener })
				if self.isPending then
					return nil
				end
				self.isPending = true
				task.defer(function()
					local ghostingLevel = pending:iter():enumerate():map(function(_param)
						local i = _param[1]
						local _binding_4 = _param[2]
						local x = _binding_4[1]
						local nextAction = pending:asPtr()[i + 1 + 1]
						local _result
						if nextAction then
							local _exp = x:GetActiveInputs()
							local _arg0 = function(rawAction)
								local _exp_1 = nextAction[1]:GetActiveInputs()
								local _arg0_1 = function(r)
									return rawAction == r
								end
								-- ▼ ReadonlyArray.some ▼
								local _result_1 = false
								for _k, _v in ipairs(_exp_1) do
									if _arg0_1(_v, _k - 1, _exp_1) then
										_result_1 = true
										break
									end
								end
								-- ▲ ReadonlyArray.some ▲
								return _result_1
							end
							-- ▼ ReadonlyArray.filter ▼
							local _newValue = {}
							local _length = 0
							for _k, _v in ipairs(_exp) do
								if _arg0(_v, _k - 1, _exp) == true then
									_length += 1
									_newValue[_length] = _v
								end
							end
							-- ▲ ReadonlyArray.filter ▲
							_result = #_newValue
						else
							_result = 0
						end
						return _result
					end):fold(0, function(acc, i)
						return acc + i
					end)
					if ghostingCap <= 0 or ghostingLevel <= ghostingCap then
						local _binding_4 = pending:iter():maxByKey(function(_param)
							local x = _param[1]
							return #x:GetActiveInputs()
						end):expect(CHOSEN_ACTION_UNWRAP_ERROR)
						local chosenAction = _binding_4[1]
						local chosenListener = _binding_4[2]
						if isSync == true or t.actionEntryIs(chosenAction, "SynchronousAction") then
							chosenListener()
						elseif not queue.Entries:iter():any(function(_param)
							local x = _param.action
							return action == x
						end) then
							queue:Add(chosenAction, chosenListener)
						end
					end
					pending:clear()
					self.isPending = false
				end)
			end
		end)
		connection:Destroyed(function()
			self:Unbind(action)
		end)
	end
	function Context:RemoveAction(actionOpt)
		return actionOpt:okOr(rustWarn(ACTION_REMOVAL_WARNING)):map(function(action)
			self.actions:remove(action)
			action:Destroy()
		end)
	end
	function Context:Has(action)
		return self.actions:containsKey(action)
	end
	function Context:Bind(action, listener)
		local _binding_2 = self
		local actions = _binding_2.actions
		if t.isAction(action) then
			self:ConnectAction(action)
			actions:insert(action, listener)
		else
			local actionEntry = transformAction(action)
			self:ConnectAction(actionEntry)
			actions:insert(actionEntry, listener)
		end
		return self
	end
	function Context:_BindEvent(name, event, listener, isSync)
		local _binding_2 = self
		local events = _binding_2.events
		local action = Manual.new()
		local onEvent = function(...)
			local args = { ... }
			return action:Trigger(unpack(args))
		end
		local connection
		if event.Connect ~= nil then
			connection = event:Connect(onEvent)
		elseif event.connect ~= nil then
			connection = event:connect(onEvent)
		else
			error(SIGNAL_NO_CONNECT_METHOD_ERROR)
		end
		local entry = {
			action = if isSync then Sync.new(action) else action,
			connection = connection,
		}
		events:tryInsert(name, entry):orElse(function()
			self:UnbindEvent(name)
			return Ok(entry)
		end):andWith(function(e)
			self:Bind(e.action, listener)
			return Ok(e)
		end)
	end
	function Context:BindEvent(name, event, listener)
		self:_BindEvent(name, event, listener, false)
		return self
	end
	function Context:BindSyncEvent(name, event, listener)
		self:_BindEvent(name, event, listener, true)
		return self
	end
	function Context:Unbind(action)
		local _binding_2 = self
		local actions = _binding_2.actions
		if t.isAction(action) then
			self:RemoveAction(actions:getKeyValue(action):map(function(_param)
				local x = _param[1]
				return x
			end))
		elseif t.isRawAction(action) then
			self:RemoveAction(actions:keys():find(function(_param)
				local RawAction = _param.RawAction
				return RawAction == action
			end))
		end
		return self
	end
	function Context:UnbindEvent(name)
		local _binding_2 = self
		local events = _binding_2.events
		events:removeEntry(name):andWith(function(_param)
			local _binding_3 = _param[2]
			local action = _binding_3.action
			local connection = _binding_3.connection
			if connection.Disconnect ~= nil then
				connection:Disconnect()
			elseif connection.disconnect ~= nil then
				connection:disconnect()
			else
				error(SIGNAL_CONNECTION_NO_DISCONNECT_METHOD_ERROR)
			end
			events:remove(name)
			self:Unbind(action)
			return Some({})
		end):okOr(rustWarn(EVENT_NOT_BOUND_WARNING(name)))
		return self
	end
	function Context:UnbindAllActions()
		local _binding_2 = self
		local actions = _binding_2.actions
		local events = _binding_2.events
		actions:keys():filter(function(action)
			return not events:values():any(function(_param)
				local x = _param.action
				return x == action
			end)
		end):forEach(function(action)
			return self:Unbind(action)
		end)
		return self
	end
	function Context:UnbindAllEvents()
		local _binding_2 = self
		local events = _binding_2.events
		events:keys():forEach(function(name)
			return self:UnbindEvent(name)
		end)
		return self
	end
	function Context:UnbindAll()
		self:UnbindAllActions()
		self:UnbindAllEvents()
		return self
	end
end
return {
	Context = Context,
}
