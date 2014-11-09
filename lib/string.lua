string = string or {}

function string.Explode(str, char)
	local index = 0
	local segs = {}
	for word in str:gmatch("[^ ]+") do
		segs[#segs+1] = word
	end
	return segs
end