function table_dump(table)
  if type(table) == 'table' then
     local s = '{ '
     for k,v in pairs(table) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. table_dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(table)
  end
end
