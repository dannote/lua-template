local template = {}

function template.escape(data)
  return tostring(data or ''):gsub("[\">/<'&]", {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
  })
end

function template.print(data, args, callback)
  local callback = callback or print
  local function exec(data)
    if type(data) == "function" then
      local args = args or {}
      setmetatable(args, { __index = _G })
      setfenv(data, args)
      data(exec)
    else
      callback(tostring(data or ''))
    end
  end
  exec(data)
end

function template.parse(data, minify)
  local str = 
    "return function(_)" .. 
      "function __(...)" ..
        "_(require('template').escape(...))" ..
      "end " ..
      "_[=[" ..
      data:
        gsub("[][]=[][]", ']=]_"%1"_[=['):
        gsub("<%%=", "]=]_("):
        gsub("<%%", "]=]__("):
        gsub("%%>", ")_[=["):
        gsub("<%?", "]=] "):
        gsub("%?>", " _[=[") ..
      "]=] " ..
    "end"
  if minify then
    str = str:
      gsub("^[ %s]*", ""):
      gsub("[ %s]*$", ""):
      gsub("%s+", " ")
  end
  return str
end

function template.compile(...)
  return loadstring(template.parse(...))()
end

return template