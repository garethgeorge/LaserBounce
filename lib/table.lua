table = table or {}

function table.Empty(tbl)
	for k,v in pairs(tbl)do
		tbl[k] = nil
	end
end