local ok, res = pcall(function()
    if type(os) ~= 'table' or type(os.time) ~= 'function' then return false end
    local t = os.time()
    assert(type(t) == 'number')
    return true
end)
return ok, res
