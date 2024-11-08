-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local HashMap = TS.import(script, TS.getModule(script, "@rbxts", "rust-classes").out).HashMap
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
local isOptional = TS.import(script, script.Parent.Parent, "Misc", "IsOptional").isOptional
--[[
	*
	* Variant that requires **only one** of its entries to be active for it to trigger.
]]
local UniqueAction
do
	local super = BaseAction
	UniqueAction = setmetatable({}, {
		__tostring = function()
			return "UniqueAction"
		end,
		__index = super,
	})
	UniqueAction.__index = UniqueAction
	function UniqueAction.new(...)
		local self = setmetatable({}, UniqueAction)
		return self:constructor(...) or self
	end
	function UniqueAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
		self.status = HashMap:empty()
		local status = (self.status)
		for _, entry in ipairs(self.RawAction) do
			local action = transformAction(entry)
			if isOptional(action) then
				ActionConnection:From(action):Triggered(function()
					return (self.Triggered):Fire(self.Context.Options.Process)
				end)
			else
				status:insert(action, false)
			end
		end
		ActionConnection:From(self):Changed(function()
			local count = status:values():filter(function(isPressed)
				return isPressed
			end):count()
			if not self.IsActive and count == 1 then
				return self:SetTriggered(true)
			end
			if self.IsActive and count == 0 then
				self:SetTriggered(false)
			end
		end)
	end
	function UniqueAction:OnConnected()
		local _binding = self
		local status = _binding.status
		status:keys():forEach(function(action)
			local connection = ActionConnection:From(action)
			action:SetContext(self.Context)
			connection:Triggered(function()
				status:insert(action, true);
				(self.Changed):Fire()
			end)
			connection:Released(function()
				status:insert(action, false);
				(self.Changed):Fire()
			end)
			ActionConnection:From(self):Destroyed(function()
				action:Destroy()
			end)
		end)
	end
end
local actionMt = UniqueAction
actionMt.__tostring = function(c)
	return "Unique(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	UniqueAction = UniqueAction,
}
