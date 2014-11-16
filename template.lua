local template = {}

function template.print(data, args, callback)
  local callback = callback or print
  local function exec(data)
    if type(data) == "function" then
      setfenv(data, args or {})
      data(exec)
    else
      callback(data)
    end
  end
  exec(data)
end

function template.parse(data)
  return "return function(_) _[=[" ..
    data:gsub("<%%", "]=]_("):gsub("%%>", ")_[=["):gsub("<%?", "]=] "):gsub("%?>", " _[=[") ..
    "]=] end"
end

function template.compile(data)
  return loadstring(template.parse(data))()
end

return template