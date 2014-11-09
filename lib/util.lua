util = util or {}

local util = util

function util.pickBest(tbl, comparator)
	local obj = tbl[1]

	for i = 2, #tbl do
		if comparator(tbl[i], obj) then
			obj = tbl[i]
		end
	end
	return obj
end


function util.memoize(func)
	local results = {}

	return function(arg)
		if results[arg] then
			return results[arg]
		else
			local res = func(arg)
			results[arg] = res
			return res
		end
	end
end

-- like a bloody boss
function util.intersection(x1, y1, x2, y2, x3, y3, x4, y4)
	local d_x1x2 = x1-x2
	local d_y1y2 = y1-y2
	local d_y3y4 = y3-y4
	local d_x3x4 = x3-x4

	local denom = d_x1x2 * d_y3y4 - d_y1y2 * d_x3x4 -- same for both
	if denom == 0 then return nil end -- if it is zero they are parallel
	
	local d_x1y2_y1x2 = (x1*y2 - y1*x2)
	local d_x3y4_y3x4 = (x3*y4 - y3*x4)

	local x = ( d_x1y2_y1x2 * d_x3x4 - d_x1x2 * d_x3y4_y3x4 ) / denom
	local y = ( d_x1y2_y1x2 * d_y3y4 - d_y1y2 * d_x3y4_y3x4 ) / denom

	return x, y
end

function util.intersection_fraction(x1, y1, x2, y2, x3, y3, x4, y4)
	local denom = (x1-x2) * (y3-y4) - (y1-y2) * (x3-x4) -- same for both
	if denom == 0 then return nil end -- if it is zero they are parallel
	return ((x3*y4 - y3*x4) - (x1*y2 - y1*x2)) / denom
end





