map = {}
local mirrors = {}
local lasers = {}
local goals = {}
map.mirrors = mirrors
map.lasers = lasers
map.goals = goals

map.selected_mirror = nil


function map.addMirror( mirror_obj )
	mirrors[#mirrors+1] = mirror_obj
end
function map.addLaser( laser_obj )
	lasers[#lasers+1] = laser_obj
end
function map.addGoal( goal_obj )
	goals[#goals+1] = goal_obj
end

function map.getSelectable()
	local selectable = {}
	for i = 1, #mirrors do
		if not mirrors[i].static then
			selectable[#selectable+1] = mirrors[i]
		end
	end
	return selectable
end

-- show a highlight on the mirror closest to the mouse
local function drawClosestHalo()
	local mousex, mousey = love.mouse.getPosition()
	local distFunc = util.memoize(function(mirror)
			return math.distance2d(mirror.x, mirror.y, mousex, mousey)
		end)
	local closestMirror = util.pickBest(map.getSelectable(), function(a,b)
			return distFunc(a) < distFunc(b)
		end)

	if not closestMirror or distFunc(closestMirror) > 60 then return end

	love.graphics.setColor(0,255,255,255)
	closestMirror:drawHalo()
end


function map.draw()
	drawClosestHalo()
	love.graphics.setShader(effect_mirror)
	for i = 1, #mirrors do
		mirrors[i]:draw()
	end
	love.graphics.setShader(effect_laser)
	for i = 1, #goals do
		goals[i].hit = false
		goals[i]:draw()
	end
	for i = 1, #lasers do
		lasers[i]:draw()
	end
	love.graphics.setShader()

	local haveWon = true
	for i = 1, #goals do
		if not goals[i].hit then
			haveWon = false
			break
		end
	end
	if haveWon then
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(font_big)
		love.graphics.print('YOU HAVE WON!', SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5, math.cos(love.timer.getTime()*2)*0.1, 1, 1, 100, 15)
		love.graphics.setFont(font_default)
	end
end

hook.Add('draw', map.draw)

function map.selectMirror( x, y, button )
	local distFunc = util.memoize(function(mirror)
			return math.distance2d(mirror.x, mirror.y, x, y)
		end)
	local closestMirror = util.pickBest(EDITING and map.mirrors or map.getSelectable(), function(a,b)
			return distFunc(a) < distFunc(b)
		end)
	
	if map.selected_mirror then
		map.selected_mirror.selected = false
	end
	if not closestMirror or distFunc(closestMirror) > 60 then
		map.selected_mirror = nil
	else
		map.selected_mirror = closestMirror
		map.selected_mirror.selected = true
	end
end

hook.Add('mousepressed_left', map.selectMirror)

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
				h = v.height,
				s = v.static
			})
	end

	local save_lasers = {}
	save_tbl.lasers = save_lasers
	for k,v in pairs(lasers)do
		table.insert(save_lasers, {
				x = v.getX(),
				y = v.getY(),
				c = v.c,
			})
	end

	local save_goals = {}
	save_tbl.goals = save_goals
	for k,v in pairs(goals)do
		table.insert(save_goals, {
			x = v.x,
			y = v.y,
			c = v.c,
			r = v.r
		})
	end

	return save_tbl 
end

function map.loadFromTable(tbl)
	table.Empty(mirrors)
	table.Empty(lasers)
	table.Empty(goals)

	-- mirrors
	for k,v in pairs(tbl.mirrors or {})do
		print(' - loaded mirror ' .. v.x.. ' - ' .. v.y )
		local mirror = newMirror()
		mirror.width = v.w
		mirror.height = v.h
		mirror.static = v.s
		mirror:setPos(v.x, v.y)
		mirror:setAngle(v.a)
		map.addMirror(mirror)
	end

	-- lasers
	for k,v in pairs(tbl.lasers or {}) do
		print(' - loaded laser '..v.x..' - '..v.y)
		local col = Color(v.c.r, v.c.g, v.c.b, v.c.a)
		local laser = newLaser(v.x, v.y, col)
		map.addLaser(laser)
	end

	-- goals
	for k,v in pairs(tbl.goals or {}) do
		print(' - loaded goal '..v.x..' - '..v.y)
		local col = Color(v.c.r, v.c.g, v.c.b, v.c.a)
		local goal = newGoal()
		goal:setColor(col)
		goal:setRadius(v.r)
		goal:setPos(v.x, v.y)
		map.addGoal(goal)
	end
end

function map.saveToFile(mapid)
	if not love.filesystem.isDirectory('maps') then
		love.filesystem.createDirectory('maps')
	end

	local data = json.encode(map.saveToTable())
	love.filesystem.write('maps/'..mapid..'.map', data, data:len())
end

function map.loadFromFile(mapid)
	local path = 'maps/'..mapid..'.map'
	local data = love.filesystem.read(path, love.filesystem.getSize(path))
	map.loadFromTable(json.decode(data))
end

console.addCommand('load', function(args)
	if not args[1] then
		print 'please enter a file name'
		return
	end
	print('loading map from file '..'maps/'..args[1]..'.map')
	map.loadFromFile(args[1])
end)

console.addCommand('save', function(args)
	if not args[1] then 
		print 'please enter a file name.'
		return
	end
	print('saving map to file '..'maps/'..args[1]..'.map')
	map.saveToFile(args[1])
end)
