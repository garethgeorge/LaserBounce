local width = 100
local widthh = width * 0.5
local height = 10
local heighth = height * 0.5

local mirror_mt = {}
mirror_mt.__index = mirror_mt

mirror_mt.width = width
mirror_mt.height = height

function mirror_mt:setPos(x, y)
	self.x = x 
	self.y = y
	self:doMath()
end

function mirror_mt:setAngle(a)
	self.a = a
	self:doMath()
end

function mirror_mt:doMath()
	local a = self.a

	self.world_x1 = self.x - math.cos(a) * widthh
	self.world_x2 = self.x + math.cos(a) * widthh

	self.world_y1 = self.y - math.sin(a) * widthh
	self.world_y2 = self.y + math.sin(a) * widthh

	local dx = self.world_x2 - self.world_x1
	local dy = self.world_y2 - self.world_y1

	self.n1x = math.cos(a + 3.14159*0.5)
	self.n1y = math.sin(a + 3.14159*0.5)

	self.n2x = math.cos(a - 3.14159*0.5)
	self.n2y = math.sin(a - 3.14159*0.5)

	self.world_n1x = self.n1x + self.x
	self.world_n1y = self.n1y + self.y


	self.world_n2x = self.n2x + self.x
	self.world_n2y = self.n2y + self.y
end

function mirror_mt:rotate(a)
	self:setAngle(self.a + a)
end

function mirror_mt:preDraw()
	love.graphics.push()

	love.graphics.translate(self.x, self.y)
	love.graphics.rotate(self.a)
	
end

function mirror_mt:postDraw()
	love.graphics.pop()
end

function mirror_mt:draw()
	self:preDraw()
	if self.selected and love.timer.getTime()*2 % 1 < 0.5 then
		love.graphics.setColor(255,255,255,255)
	else
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.rectangle( 'fill', -50, -5, 100, 10)


	self:postDraw()
end

function mirror_mt:drawHalo(r, g, b, a)
	self:preDraw()
	love.graphics.rectangle( 'fill', -51, -6, 102, 12)
	self:postDraw()
end

function mirror_mt:getNearestNormal(x, y)
	local d1 = math.distance2d(x, y, self.world_n1x, self.world_n1y)
	local d2 = math.distance2d(x, y, self.world_n2x, self.world_n2y)

	if d1 < d2 then
		return self.n1x, self.n1y
	else
		return self.n2x, self.n2y
	end
end

function mirror_mt:onBounce()
	-- OVERRIDE
end


function newMirror()
	local newMirror = setmetatable({a=0, x=0, y=0}, mirror_mt)
	return newMirror
end


hook.Add('keypressed', function(key)
	if map.selected_mirror then
		if key == 'up' or key == 'right' then
			map.selected_mirror:rotate(3.141592653589/24)
			return true
		elseif key == 'down' or key == 'left' then
			map.selected_mirror:rotate(-3.141592653589/24)
			return true
		end
	end
end)