local ok, res = pcall(function()
    if type(coroutine) ~= 'table' then return false end
    local co = coroutine.create(function(x) return x*2 end)
    local s, r = coroutine.resume(co, 4)
    assert(s and r == 8)
    return true
end)
return ok, res
