-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
-- Original from: https://github.com/Dionysusnu/rbxts-rust-classes/blob/fa417965ef3c61fc2cdc0c1e1436f3153e007493/src/util/lazyLoad.ts
local objects = {}
local waiting = {}
local function lazyLoad(name, callback)
	local obj = objects[name]
	if obj then
		callback(obj)
	else
		local waiter = waiting[name]
		if waiter then
			local _exp = waiter[1]
			local _arg0 = function(c)
				return callback(c)
			end
			_exp:andThen(_arg0)
		else
			local prom
			prom = TS.Promise.new(function(resolve)
				waiting[name] = { prom, resolve }
			end)
			local waiter = waiting[name]
			waiter[1] = prom
			local _arg0 = function(c)
				return callback(c)
			end
			prom:andThen(_arg0)
		end
	end
end
local function lazyRegister(name, action)
	objects[name] = action
	local waiter = waiting[name]
	if waiter then
		waiter[2](action)
	end
end
return {
	lazyLoad = lazyLoad,
	lazyRegister = lazyRegister,
}
