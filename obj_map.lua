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
	love.graphics.setShader(effect_mirror)
	for i = 1, #mirrors do
		mirrors[i]:draw()
	end
	love.graphics.setShader(effect_laser)
	for i = 1, #lasers do
		lasers[i]:draw()
	end
	love.graphics.setShader()
end

hook.Add('draw', map.draw)

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

hook.Add('mousepressed', map.selectMirror)

function map.saveToTable()
	local save_tbl = {}
	local save_mirrors = {}
	save_tbl.mirrors = save_mirrors

	for k,v in pairs(mirrors)do
		table.insert(save_mirrors, {
				x = v.x,
				y = v.y,
				a = v.a,
				w = v.width,
				h = v.height
			})
	end
	return save_tbl
end

function map.loadFromTable(tbl)
	for k,v in pairs(tbl.mirrors)do
		local mirror = newMirror()
		mirror:setPos(v.x, v.y)
		mirror:setAngle(v.a)
	end
end

function map.saveToFile(mapid)
	if not love.filesystem.isDirectory('maps') then
		love.filesystem.createDirectory('maps')
	end

	local data = json.encode(map.saveToTable())
	love.filesystem.write('maps/'..mapid..'.map', data, data:len())
end

hook.Add('keypressed', function(key)
	if key == 's' then
		map.saveToFile(SAVE_NAME)
	end
end)


