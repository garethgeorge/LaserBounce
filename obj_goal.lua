
local goal_mt = {}
goal_mt.__index = goal_mt

function goal_mt:setColor(c)
	self.c = c
end
function goal_mt:setRadius(r)
	self.r = r
end
function goal_mt:setPos(x, y)
	self.x, self.y = x, y
end
function goal_mt:getPos()
	return self.x, self.y
end
function goal_mt:draw()
	love.graphics.setColor(self.c:unpack())
	love.graphics.circle( 'fill', self.x, self.y, self.r, 12)
end


function newGoal()
	local obj = setmetatable({}, goal_mt)
	return obj
end