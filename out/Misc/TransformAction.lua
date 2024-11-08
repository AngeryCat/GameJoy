-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local t = TS.import(script, script.Parent.Parent, "Util", "TypeChecks")
local lazyLoad = TS.import(script, script.Parent, "Lazy").lazyLoad
local Action
lazyLoad("Action", function(action)
	Action = action
	return Action
end)
local Axis
lazyLoad("Axis", function(action)
	Axis = action
	return Axis
end)
local Union
lazyLoad("Union", function(action)
	Union = action
	return Union
end)
local function transformAction(entry)
	if not t.isValidActionEntry(entry) then
		error(debug.traceback("Invalid action entry."))
	end
	return if t.isAction(entry) then entry elseif t.isActionLikeArray(entry) then Union.new(entry) elseif t.isAxisActionEntry(entry) then Axis.new(entry) else Action.new(entry)
end
return {
	transformAction = transformAction,
}
