-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local HashMap = TS.import(script, TS.getModule(script, "@rbxts", "rust-classes").out).HashMap
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
local isOptional = TS.import(script, script.Parent.Parent, "Misc", "IsOptional").isOptional
--[[
	*
	* Variant that requires all of its entries to be active for it to trigger.
]]
local CompositeAction
do
	local super = BaseAction
	CompositeAction = setmetatable({}, {
		__tostring = function()
			return "CompositeAction"
		end,
		__index = super,
	})
	CompositeAction.__index = CompositeAction
	function CompositeAction.new(...)
		local self = setmetatable({}, CompositeAction)
		return self:constructor(...) or self
	end
	function CompositeAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
		self.status = HashMap:empty()
		local status = (self.status)
		for _, entry in ipairs(self.RawAction) do
			local action = transformAction(entry)
			status:insert(action, isOptional(action))
		end
		ActionConnection:From(self):Changed(function()
			if status:values():all(function(isPressed)
				return isPressed
			end) then
				return self:SetTriggered(true)
			end
			if self.IsActive then
				self:SetTriggered(false)
			end
		end)
	end
	function CompositeAction:OnConnected()
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
				if not isOptional(action) then
					status:insert(action, false)
				end
				(self.Changed):Fire()
			end)
			ActionConnection:From(self):Destroyed(function()
				action:Destroy()
			end)
		end)
	end
end
local actionMt = CompositeAction
actionMt.__tostring = function(c)
	return "Composite(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	CompositeAction = CompositeAction,
}
