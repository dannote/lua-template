local template = {}

function template.print(data, args, callback)
  local callback = callback or print
  local function exec(data)
    if type(data) == "function" then
      local args = args or {}
      setmetatable(args, { __index = _G })
      setfenv(data, args)
      data(exec)
    else
      callback(data)
    end
  end
  exec(data)
end

function template.parse(data, minify)
  local str = "return function(_) _[=[" ..
    data:gsub("<%%", "]=]_("):gsub("%%>", ")_[=["):gsub("<%?", "]=] "):gsub("%?>", " _[=[") ..
    "]=] end"
  if minify then
    return str:gsub("(^[ %s]*|[ %s]*$)", ""):gsub("%s+", " ")
  else
    return str
  end
end

function template.compile(...)
  return loadstring(template.parse(...))()
end

return template