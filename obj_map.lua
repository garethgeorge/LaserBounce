map = {}
local mirrors = {}
local lasers = {}
map.mirrors = mirrors
map.lasers = lasers


map.selected_mirror = nil


function map.addMirror( mirror_obj )
	mirrors[#mirrors+1] = mirror_obj
end
function map.addLaser( laser_obj )
	lasers[#lasers+1] = laser_obj
end

-- show a highlight on the mirror closest to the mouse
local function drawClosestHalo()
	local mousex, mousey = love.mouse.getPosition()
	local distFunc = util.memoize(function(mirror)
			return math.distance2d(mirror.x, mirror.y, mousex, mousey)
		end)
	local closestMirror = util.pickBest(mirrors, function(a,b)
			return distFunc(a) < distFunc(b)
		end)

	if distFunc(closestMirror) > 60 then return end

	if closestMirror then
		love.graphics.setColor(0,255,255,255)
		closestMirror:drawHalo()
	end
end


function map.draw()
	drawClosestHalo()
	for i = 1, #mirrors do
		mirrors[i]:draw()
	end

	for i = 1, #lasers do
		lasers[i]:draw()
	end
end

function map.selectMirror( x, y, button )
	local distFunc = util.memoize(function(mirror)
			return math.distance2d(mirror.x, mirror.y, x, y)
		end)
	local closestMirror = util.pickBest(mirrors, function(a,b)
			return distFunc(a) < distFunc(b)
		end)

	
	if map.selected_mirror then
		map.selected_mirror.selected = false
	end
	if distFunc(closestMirror) > 60 then
		map.selected_mirror = nil
	else
		map.selected_mirror = closestMirror
		map.selected_mirror.selected = true
	end
end