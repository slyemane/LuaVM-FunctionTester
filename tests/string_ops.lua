local ok, res = pcall(function()
    assert(string.upper("a") == "A")
    assert(string.sub("hello",2,4) == "ell")
    assert(#("abc") == 3)
    return true
end)
return ok, res
