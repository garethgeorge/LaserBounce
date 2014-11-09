require 'lib.hook'
require 'lib.math'
require 'lib.util'
require 'lib.pon'

require 'constants'
require 'obj_color'
require 'obj_mirror'
require 'obj_map'
require 'obj_laser'

function love.load()
	
    effect_laser = love.graphics.newShader [[
    	extern number time;
        float valueThingy;
        float scale;
        float r;
        float g;
        float b;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
        	valueThingy = time*10 + pixel_coords.x/30 + pixel_coords.y/60;
        	scale = cos(valueThingy) * 0.5 + 0.5;
        	scale = 0.5 + scale * 0.5;
        	r = color.r * scale;
			g = color.g * scale;
			b = color.b * scale;
            return vec4(r, g, b, 1.0);
        }
    ]]

    effect_mirror = love.graphics.newShader [[
    	extern number time;
        float valueThingy;
        float scale;
        float r;
        float g;
        float b;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
        	valueThingy = time + pixel_coords.x/50 + pixel_coords.y/100;
        	scale = 1-abs(cos(valueThingy));
        	scale = 0.5 + scale * 0.5;
        	r = color.r * scale;
			g = color.g * scale;
			b = color.b * scale;
            return vec4(r, g, b, 1.0);
        }
    ]]


	love.window.setTitle('Lasers and Mirrors')
	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {
			resizable = false
		})

	love.graphics.setBackgroundColor(0,0,0)

	local test = newMirror()
	test:setPos(SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.25)
	test:setAngle(0)
	map.addMirror(test)

	local test = newMirror()
	test:setPos(SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.5)
	test:setAngle(0)
	map.addMirror(test)

	local test = newMirror()
	test:setPos(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.25)
	test:setAngle(0)
	map.addMirror(test)

	local test = newMirror()
	test:setPos(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.5)
	test:setAngle(0)
	map.addMirror(test)

	local test = newMirror()
	test:setPos(SCREEN_WIDTH*0.75, SCREEN_HEIGHT*0.5)
	test:setAngle(0)
	test.onBounce = function()
		GAME_STATE = 'winner'
	end
	map.addMirror(test)

	local laser = newLaser(0, SCREEN_WIDTH * 0.5)
	map.addLaser(laser)
end

function love.draw()

	MOUSE_X = love.mouse.getX()
	MOUSE_Y = love.mouse.getY()

	love.graphics.clear()
	love.graphics.setColor(255,255,255)

	hook.Call('draw')
end

local t = 0
function love.update(dt)
    t = t + dt
    effect_laser:send("time", t)
    effect_mirror:send("time", t)

	hook.Call('update', dt)
end

function love.mousepressed( x, y, button )
	hook.Call('mousepressed', x, y, button)
	if button == 'l' then
		hook.Call('mousepressed_left', x, y, 'l')
	elseif button == 'r' then
		hook.Call('mousepressed_right', x, y, 'r')
	elseif button == 'm' then
		hook.Call('mousepressed_middle', x, y, 'm')
	end
end

function love.keypressed( key, isrepeat )
	hook.Call('keypressed', key, isrepeat)

	if key == 'e' then
		EDITING = not EDITING
	end
end