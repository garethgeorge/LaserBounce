math = math or {}
local math = math
local sqrt = math.sqrt

math.distance2d = function(x1, y1, x2, y2)
	local dx = x1-x2
	local dy = y1-y2
	return sqrt(dx*dx + dy*dy)
end