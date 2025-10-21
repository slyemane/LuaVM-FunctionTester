local ok, res = pcall(function()
    assert(math.abs(-5) == 5)
    assert(math.floor(3.9) == 3)
    assert(math.max(1,2,3) == 3)
    return true
end)
return ok, res
