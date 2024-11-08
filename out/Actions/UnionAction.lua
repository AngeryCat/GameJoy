-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local ActionConnection = TS.import(script, script.Parent.Parent, "Class", "ActionConnection").ActionConnection
local BaseAction = TS.import(script, script.Parent.Parent, "Class", "BaseAction").BaseAction
local transformAction = TS.import(script, script.Parent.Parent, "Misc", "TransformAction").transformAction
--[[
	*
	* Variant that accepts multiple entries as a parameter.
]]
local UnionAction
do
	local super = BaseAction
	UnionAction = setmetatable({}, {
		__tostring = function()
			return "UnionAction"
		end,
		__index = super,
	})
	UnionAction.__index = UnionAction
	function UnionAction.new(...)
		local self = setmetatable({}, UnionAction)
		return self:constructor(...) or self
	end
	function UnionAction:constructor(RawAction)
		super.constructor(self)
		self.RawAction = RawAction
	end
	function UnionAction:OnConnected()
		local thisConnection = ActionConnection:From(self)
		for _, entry in ipairs(self.RawAction) do
			local action = transformAction(entry)
			local connection = ActionConnection:From(action)
			action:SetContext(self.Context)
			connection:Triggered(function()
				self:SetTriggered(true);
				(self.Changed):Fire()
			end)
			connection:Released(function()
				self:SetTriggered(false);
				(self.Changed):Fire()
			end)
			thisConnection:Destroyed(function()
				action:Destroy();
				(self.Changed):Fire()
			end)
		end
	end
end
local actionMt = UnionAction
actionMt.__tostring = function(c)
	return "Union(" .. (table.concat(c:GetContentString(), ", ") .. ")")
end
return {
	UnionAction = UnionAction,
}
