local console_text = {}
console = {}
console.open = false
console.allowed_chars = 'abcdefghijklmnopqrstuvwxyz _-+/!#@'
console.cur_line = ''
console.commands = {}
function console.toggle()
	console.open = not console.open

	love.keyboard.setKeyRepeat(console.open)
	love.keyboard.setTextInput(console.open)
end

function console.print(text)
	table.insert(console_text, 1, text)
	if #console_text == 11 then
		console_text[11] = nil
	end
end

function console.paint()
	love.graphics.setColor(200,200,200)
	love.graphics.print(' > '..console.cur_line..(love.timer.getTime() % 0.4 < 0.2 and '|' or ''), 10, 10);
	for i = 1, #console_text do
		love.graphics.print(console_text[i], 10, 10 + i * 20)
	end
end
function console.addCommand(cmd, func)
	console.commands[cmd] = func
end

print = console.print

require 'lib.table'
require 'lib.string'
require 'lib.hook'
require 'lib.math'
require 'lib.util'
require 'lib.pon'

require 'constants'
require 'obj_color'
require 'obj_mirror'
require 'obj_map'
require 'obj_laser'
require 'obj_goal'
require 'edit'

function love.load()
	
    effect_laser = love.graphics.newShader([[
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
        	scale = 0.6 + scale * 0.4;
        	r = color.r * scale;
			g = color.g * scale;
			b = color.b * scale;
            return vec4(r, g, b, 1.0);
        }
    ]]) 

   

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
        	scale = 0.6 + scale * 0.4;
        	r = color.r * scale;
			g = color.g * scale;
			b = color.b * scale;
            return vec4(r, g, b, 1.0);
        }
    ]]

    font_default = love.graphics.newFont(12)
    font_big = love.graphics.newFont(30)


	love.window.setTitle('Lasers and Mirrors')
	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {
			resizable = false
		})

	love.graphics.setBackgroundColor(0,0,0)

end




function love.draw()
	MOUSE_X = love.mouse.getX()
	MOUSE_Y = love.mouse.getY()

	love.graphics.setFont(font_default)
	love.graphics.clear()
	love.graphics.setColor(255,255,255)

	hook.Call('draw')

	if console.open then
		console.paint()
	end
end

local t = 0
function love.update(dt)
    t = t + dt
    effect_laser:send("time", t)
    effect_mirror:send("time", t)

	hook.Call('update', dt)
end

function love.mousepressed( x, y, button)
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
	if key == '`' then
		console.toggle()
	elseif console.open then
		if key == 'backspace' then
			console.cur_line = console.cur_line:sub(1, console.cur_line:len() - 1)
		elseif key == 'kpenter' or key == 'return' then
			local cmd = console.cur_line
			local args = string.Explode(cmd)
			console_text[#console_text+1] = cmd

			local cmd_name = table.remove(args, 1)
			if console.commands[cmd_name or 'noneeeee'] then
				console.commands[cmd_name](args)
			else
				print('command '..cmd_name..' not found.')
			end

			console.cur_line = ''
		end
	else
		hook.Call('keypressed', key, isrepeat)

		if key == 'e' then
			EDITING = not EDITING
		end
	end
end

function love.textinput(t)
	if t == '`' then return end
	console.cur_line = console.cur_line .. t
end