local color_mt = {}
color_mt.__index = color_mt

function color_mt:unpack()
	return self.r, self.g, self.b, self.a
end

function Color( r, g, b, a )
	return setmetatable({
		r = r,
		g = g,
		b = b,
		a = a == nil and 255 or a
	}, color_mt)
end