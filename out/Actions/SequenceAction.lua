-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local Vec = TS.import(script, TS.getModule(script, "@rbxts", "rust-classes").out).Vec
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
local isOptional = TS.import(script, script.Parent.Parent, "Misc", "IsOptional").isOptional
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
--[[
	*
	* Variant that requires all of its entries to be active in a specific order for it to trigger.
]]
local SequenceAction
do
	local super = BaseAction
	SequenceAction = setmetatable({}, {
		__tostring = function()
			return "SequenceAction"
		end,
		__index = super,
	})
	SequenceAction.__index = SequenceAction
	function SequenceAction.new(...)
		local self = setmetatable({}, SequenceAction)
		return self:constructor(...) or self
	end
	function SequenceAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
		self.Cancelled = Signal.new()
		local _arg0 = function(action)
			return not t.isAction(action) or not isOptional(action)
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(RawAction) do
			if _arg0(_v, _k - 1, RawAction) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local rawActions = _newValue
		self.queue = Vec:withCapacity(#rawActions)
		local queue = (self.queue)
		self.canCancel = false
		ActionConnection:From(self):Changed(function()
			local size = queue:len()
			if size > 0 and queue:iter():enumerate():all(function(_param)
				local i = _param[1]
				local entry = _param[2]
				return RawAction[i + 1] == entry
			end) then
				self.canCancel = true
				if size == #rawActions then
					self.canCancel = false
					return self:SetTriggered(true)
				end
			end
			if self.IsActive then
				local _fn = self
				self.canCancel = false
				_fn:SetTriggered((self.canCancel))
			end
		end)
	end
	function SequenceAction:OnConnected()
		local _binding = self
		local queue = _binding.queue
		for _, entry in ipairs(self.RawAction) do
			local action = transformAction(entry)
			local connection = ActionConnection:From(action)
			action:SetContext(self.Context)
			local began = false
			connection:Triggered(function()
				if not isOptional(entry) then
					queue:push(entry)
				end
				began = true
				(self.Changed):Fire()
			end)
			connection:Released(function()
				local _exp = queue:asPtr()
				local _arg0 = function(x)
					return x == entry
				end
				-- ▼ ReadonlyArray.findIndex ▼
				local _result = -1
				for _i, _v in ipairs(_exp) do
					if _arg0(_v, _i - 1, _exp) == true then
						_result = _i - 1
						break
					end
				end
				-- ▲ ReadonlyArray.findIndex ▲
				local index = _result
				if began and index >= 0 then
					queue:remove(index)
				end
				began = false
				if self.canCancel then
					self.canCancel = false
					(self.Cancelled):Fire()
				end
				(self.Changed):Fire()
			end)
			ActionConnection:From(self):Destroyed(function()
				action:Destroy()
			end)
		end
	end
end
local actionMt = SequenceAction
actionMt.__tostring = function(c)
	return "Sequence(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	SequenceAction = SequenceAction,
}
