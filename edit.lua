
console.addCommand('newmirror', function(args)
	local test = newMirror()
	test:setPos(SCREEN_WIDTH*math.random(), SCREEN_HEIGHT*math.random())
	test:setAngle(0)
	map.selected_mirror = test
	test.selected = true
	map.addMirror(test)
end)

console.addCommand('edit', function(args)
	EDITING = true
end)

console.addCommand('setwidth', function(args)
	if map.selected_mirror then
		if not tonumber(args[1]) then
			print('please provide a numeric width.')
		else
			map.selected_mirror.width = tonumber(args[1])
		end
	end
end)

console.addCommand('drawstatic', function(args)
	print 'click the first position'
	local mousepressed = love.mousepressed
	love.mousepressed = function(x1, y1)
		print 'click the second position'
		love.mousepressed = function(x2, y2)
			print 'creating object'
			local mirror = newMirror()
			mirror.static = true
			mirror.width = math.distance2d(x1, y1, x2, y2)
			mirror:setPos((x1+x2)*0.5, (y1+y2)*0.5)
			mirror:setAngle(math.atan2(y1-y2, x1-x2))
			map.addMirror(mirror)

			love.mousepressed = mousepressed
		end
	end
end)

hook.Add('mousepressed_right', function(x, y)
	if EDITING and map.selected_mirror then
		map.selected_mirror:setPos(x, y)
	end
end)

hook.Add('draw', function()
	if EDITING then
		love.graphics.setColor(255,255,255)
		love.graphics.print('EDITING: true', 10, SCREEN_HEIGHT - 30)
	end
end)