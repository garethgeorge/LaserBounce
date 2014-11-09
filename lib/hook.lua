hook = {}

local hooks = {}
function hook.Add(type, func)
	if not hooks[type] then hooks[type] = {} end
	table.insert(hooks[type], func)
end

function hook.Call(type, ...)
	local hooks = hooks[type]
	if not hooks then return end
	
	local a, b, c, d
	for i = 1, #hooks do
		a, b, c, d = hooks[i](...)
		if a ~= nil and b ~= nil then
			return a, b, c, d
		end
	end
end