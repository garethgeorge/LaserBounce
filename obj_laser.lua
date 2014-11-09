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

	function self.draw()
		love.graphics.setColor(0,255,255,255)

		local x, y = x, y
		local xdir, ydir = 1, 0

		local mirrors = map.mirrors
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
			

			local mirror -- temp variable
			local best_mirror -- best mirror we have so far
			local best_distance = 0

			-- current xhit coordinate
			local xhit = nil
			local yhit = nil

			local inter_x, inter_y, frac, dist

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

			if best_mirror then
				last_mirror_hit = best_mirror
				
				love.graphics.line(x, y, xhit, yhit)
				love.graphics.line(x, y, xhit, yhit)
				local nx, ny = best_mirror:getNearestNormal(x, y)
				nx, ny = -ny, nx
				xdir, ydir = util.mirror(xdir, ydir, 0, 0, nx, ny)
				x = xhit
				y = yhit

				best_mirror:onBounce()

				drawPass()
			else
				love.graphics.line(x, y, x2, y2)
			end
		end

		drawPass()
	end

	-- recursive algorithm that keeps drawing between intersection points OR off into infinity and terminates.
	return self
end
