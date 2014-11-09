local width = 100
local widthh = width * 0.5
local height = 10
local heighth = height * 0.5

local mirror_mt = {}
mirror_mt.__index = mirror_mt
function mirror_mt:setPos(x, y)
	self.x = x 
	self.y = y
end

function mirror_mt:setAngle(a)
	self.a = a
	self.world_x1 = self.x - math.cos(a) * widthh
	self.world_x2 = self.x + math.cos(a) * widthh

	self.world_y1 = self.y - math.sin(a) * widthh
	self.world_y2 = self.y + math.sin(a) * widthh
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
		love.graphics.setColor(self.c:unpack())
	end
	love.graphics.rectangle( 'fill', -50, -5, 100, 10)


	self:postDraw()
end

function mirror_mt:drawHalo(r, g, b, a)
	self:preDraw()
	love.graphics.rectangle( 'fill', -51, -6, 102, 12)
	self:postDraw()
end


function newMirror(c)
	local newMirror = setmetatable({}, mirror_mt)
	newMirror.c = c
	return newMirror
end