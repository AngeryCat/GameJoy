-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local exports = {}
local lazyRegister = TS.import(script, script.Parent, "Misc", "Lazy").lazyRegister
local Action = TS.import(script, script, "Action").Action
lazyRegister("Action", Action)
local Axis = TS.import(script, script, "AxisAction").AxisAction
lazyRegister("Axis", Axis)
exports.Composite = TS.import(script, script, "CompositeAction").CompositeAction
exports.Dynamic = TS.import(script, script, "DynamicAction").DynamicAction
exports.Manual = TS.import(script, script, "ManualAction").ManualAction
exports.Middleware = TS.import(script, script, "MiddlewareAction").MiddlewareAction
exports.Optional = TS.import(script, script, "OptionalAction").OptionalAction
exports.Sequence = TS.import(script, script, "SequenceAction").SequenceAction
exports.Sync = TS.import(script, script, "SynchronousAction").SynchronousAction
local Union = TS.import(script, script, "UnionAction").UnionAction
lazyRegister("Union", Union)
exports.Unique = TS.import(script, script, "UniqueAction").UniqueAction
exports.Action = Action
exports.Axis = Axis
exports.Union = Union
return exports
