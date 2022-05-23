local tbInsert = table.insert
local tbSort = table.sort

function ternary(a, b, c)
    if a then
        return b
    else
        return c
    end
end