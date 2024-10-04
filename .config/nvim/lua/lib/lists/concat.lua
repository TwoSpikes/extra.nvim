if EXNVIM_LIB_LISTS_CONCAT_INCLUDED == nil then EXNVIM_LIB_LISTS_CONCAT_INCLUDED = true else os.exit(0) end

-- Copyied from StackOverflow: https://stackoverflow.com/questions/1410862/concatenation-of-tables-in-lua
function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end
