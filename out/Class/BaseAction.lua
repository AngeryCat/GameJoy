-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local IS = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
local TranslateRawAction = TS.import(script, script.Parent.Parent, "Util", "TranslateRawAction").TranslateRawAction
local IsInputDown = TS.import(script, script.Parent.Parent, "Util", "IsInputDown").IsInputDown
local BaseAction
do
	BaseAction = {}
	function BaseAction:constructor()
		self.IsActive = false
		self.Content = {}
		self.Connected = Signal.new()
		self.Changed = Signal.new()
		self.Resolved = Signal.new()
		self.Rejected = Signal.new()
		self.Triggered = Signal.new()
		self.Released = Signal.new()
		self.Destroyed = Signal.new()
		self.Destroyed:Connect(function()
			return self:SetContext(nil)
		end)
		self.Connected:Connect(function()
			self:OnConnected()
			self:LoadContent()
		end)
	end
	function BaseAction:VisitEachRawAction(action)
		if t.isAction(action) then
			self:VisitEachRawAction(action.RawAction)
		elseif t.isRawAction(action) then
			local _exp = (self.Content)
			local _arg0 = TranslateRawAction(action)
			-- ▼ Array.push ▼
			_exp[#_exp + 1] = _arg0
			-- ▲ Array.push ▲
		elseif t.isActionLikeArray(action) then
			local _arg0 = function(entry)
				return self:VisitEachRawAction(entry)
			end
			-- ▼ ReadonlyArray.forEach ▼
			for _k, _v in ipairs(action) do
				_arg0(_v, _k - 1, action)
			end
			-- ▲ ReadonlyArray.forEach ▲
		end
	end
	function BaseAction:LoadContent()
		local content = self.Content
		-- ▼ Array.clear ▼
		table.clear(content)
		-- ▲ Array.clear ▲
		self:VisitEachRawAction(self.RawAction)
	end
	function BaseAction:SetTriggered(value, ignoreEventCall, ...)
		local args = { ... }
		self.IsActive = value
		if not ignoreEventCall then
			local _fn = (self[if value == true then "Triggered" else "Released"])
			local _result = self.Context
			if _result ~= nil then
				_result = _result.Options
				if _result ~= nil then
					_result = _result.Process
				end
			end
			_fn:Fire(_result, unpack(args))
		end
	end
	function BaseAction:SetContext(context)
		local wasBound = self:IsBound()
		self.Context = context
		if not wasBound then
			(self.Connected):Fire()
		end
	end
	function BaseAction:IsBound()
		return self.Context ~= nil
	end
	function BaseAction:GetActiveInputs()
		local _content = self.Content
		local _arg0 = function(input)
			return IsInputDown(input)
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_content) do
			if _arg0(_v, _k - 1, _content) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		return _newValue
	end
	function BaseAction:GetContentString()
		local _content = self.Content
		local _arg0 = function(x)
			local code = IS:GetStringForKeyCode(x)
			return if t.isKeyCode(x) and #code > 0 then code else x.Name
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_content)
		for _k, _v in ipairs(_content) do
			_newValue[_k] = _arg0(_v, _k - 1, _content)
		end
		-- ▲ ReadonlyArray.map ▲
		return _newValue
	end
	function BaseAction:Destroy()
		(self.Destroyed):Fire()
	end
end
return {
	BaseAction = BaseAction,
}
