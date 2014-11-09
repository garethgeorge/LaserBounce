require 'lib.math'
require 'lib.util'

require 'constants'
require 'obj_color'
require 'obj_mirror'
require 'obj_map'
require 'obj_laser'

function love.load()
	love.window.setTitle('Lasers and Mirrors')
	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {
			resizable = false
		})

	love.graphics.setBackgroundColor(0,0,0)

	local test = newMirror(Color(255,0,0))
	test:setPos(SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.25)
	test:setAngle(0)
	map.addMirror(test)

	local test = newMirror(Color(255,0,255))
	test:setPos(SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.5)
	test:setAngle(0)
	map.addMirror(test)

	local test = newMirror(Color(255,0,0))
	test:setPos(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.25)
	test:setAngle(0)
	map.addMirror(test)


	local test = newMirror(Color(255,0,0))
	test:setPos(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.5)
	test:setAngle(0)
	map.addMirror(test)

	local laser = newLaser(0, SCREEN_WIDTH * 0.5)
	map.addLaser(laser)


end

function love.draw()
	MOUSE_X = love.mouse.getX()
	MOUSE_Y = love.mouse.getY()

	love.graphics.clear()

	love.graphics.setColor(255,255,255)

	map.draw()
end

function love.mousepressed( x, y, button )
	map.selectMirror( x, y )
end

function love.keypressed( key, isrepeat )
	if map.selected_mirror then
		if key == 'up' or key == 'right' then
			map.selected_mirror:rotate(3.141592653589/24)
		elseif key == 'down' or key == 'left' then
			map.selected_mirror:rotate(-3.141592653589/24)
		end
	end
end