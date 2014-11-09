function newLaser(_x, _y)
	local self = {}
	local x, y = _x, _y
	function self.getPos()
		return x, y
	end
	function self.getX()
		return x
	end
	function self.getY()
		return y
	end
	function self.setPos(x, x)
	end

	function self.renderPass(x, y, xdir, ydir, lastHit)
		
	end

	-- recursive algorithm that keeps drawing between intersection points OR off into infinity and terminates.
	return self
end