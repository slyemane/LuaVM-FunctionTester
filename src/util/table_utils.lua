local T = {}
function T.clone(t)
    local o = {}
    for k,v in pairs(t) do o[k]=v end
    return o
end
function T.keys(t)
    local out = {}
    for k,_ in pairs(t) do table.insert(out,k) end
    return out
end
return T
