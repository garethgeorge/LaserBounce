local love = love

function newLaser(_x, _y, c)
	local self = {}
	self.c = c or Color(0,255,255)
	local r, g, b = c.r, c.b, c.a

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

	function self.draw()
		love.graphics.setColor(r, g, b, c.a)
		love.graphics.circle( 'fill', x, y, 15, 12 )

		local x, y = x, y
		local xdir, ydir = 1, 0

		local mirrors = map.mirrors
		local goals = map.goals
		local last_mirror_hit = nil

		local maximum = 1000

		function drawPass()
			maximum = maximum - 1
			if maximum < 0 then return end

			local ray_length = 1000
			local x1, y1 = x, y
			local x2, y2 = x + xdir * ray_length, y + ydir * ray_length
			local ray_midpoint_x = (x1+x2)*0.5
			local ray_midpoint_y = (y1+y2)*0.5
			
			-- GENERAL VARIABLES
			local dist
			local best_distance = 0
			--
			-- FIND THE MIRROR THE RAY HITS
			--
			local mirror -- temp variable
			local best_mirror -- best mirror we have so far

			-- current xhit coordinate
			local xhit = nil
			local yhit = nil

			local inter_x, inter_y, frac

			for i = 1, #mirrors do
				mirror = mirrors[i]

				if last_mirror_hit ~= mirror then -- check it's not the same one we hit last time... last mirror is a bitch

					inter_x, inter_y = util.intersection(
							x1, y1,
							x2, y2,
							mirror.world_x1, mirror.world_y1,
							mirror.world_x2, mirror.world_y2
						)

					if inter_x ~= nil and inter_y ~= nil then
						dist = math.distance2d(inter_x, inter_y, ray_midpoint_x, ray_midpoint_y)

						if dist < ray_length * 0.5 then
							frac = math.distance2d(mirror.x, mirror.y, inter_x, inter_y)

							if frac < mirror.width * 0.5 then
								dist = math.distance2d(x, y, inter_x, inter_y)
								if not best_mirror or dist < best_distance then
									best_mirror = mirror
									best_distance = dist
									xhit = inter_x
									yhit = inter_y
								end
							end
						end
					end
				end

			end

			--
			-- FIND THE NEAREST (SHOULD BE ONLY...) GOAL
			-- 
			local best_goal
			local goal
			for i = 1, #goals do
				goal = goals[i]
				local col = goal.c
				if col.r == r and col.g == g and col.b == b then
					frac = util.distancePointToLine(goal.x, goal.y, x1, y1, x2, y2) / goal.r
					if frac < 1 then
						dist = math.distance2d(x, y, goal.x, goal.y)
						if not (best_goal or best_mirror) or dist < best_distance then
							print 'wow this worked'
							best_distance = dist
							best_mirror = nil
							best_goal = goal
						end
					end
				end
			end

			--
			-- IN CONCLUSION...
			-- 
			if best_mirror then
				last_mirror_hit = best_mirror
				
				love.graphics.line(x, y, xhit, yhit)
				local nx, ny = best_mirror:getNearestNormal(x, y)
				nx, ny = -ny, nx
				xdir, ydir = util.mirror(xdir, ydir, 0, 0, nx, ny)
				x = xhit
				y = yhit
				drawPass()
			elseif best_goal then
				best_goal.hit = true
				love.graphics.line(x, y, best_goal.x, best_goal.y)
			else
				love.graphics.line(x, y, x2, y2)
			end
		end

		drawPass()
	end

	-- recursive algorithm that keeps drawing between intersection points OR off into infinity and terminates.
	return self
end
