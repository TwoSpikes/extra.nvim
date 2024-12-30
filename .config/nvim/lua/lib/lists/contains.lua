function table_contains(tbl, x)
	found = false
	for _, v in pairs(tbl) do
		if v == x then
			found = true
		end
	end
	return found
end
