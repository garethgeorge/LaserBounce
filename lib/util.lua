util = util or {}

local util = util

function util.pickBest(tbl, comparator)
	local obj = tbl[1]

	if #tbl > 1 then
		for i = 2, #tbl do
			if tbl[i] and comparator(tbl[i], obj) then
				obj = tbl[i]
			end
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

function util.mirror(px, py, x0, y0, x1, y1)
   local dx  = (x1 - x0);
   local dy  = (y1 - y0);

   local a   = (dx * dx - dy * dy) / (dx*dx + dy*dy);
   local b   = 2 * dx * dy / (dx*dx + dy*dy);

   local x2  = (a * (px - x0) + b*(py - y0) + x0); 
   local y2  = (b * (px - x0) - a*(py - y0) + y0);

   return x2, y2;
end
