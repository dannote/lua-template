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
      local env = args or {}
      setmetatable(env, { __index = _G })
      if _ENV then -- Lua 5.2+
        local wrapper, err = load([[
          return function(_ENV, exec)
            local f = ...
            f(exec)
          end
        ]], "wrapper", "t", env)
        if not wrapper then
          error(err)
        end
        wrapper()(env, exec, data)
      else
        setfenv(data, env)
        data(exec)
      end
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
  local f, err = loadstring(template.parse(...))
  if err then
    error(err)
  end
  return f()
end

return template
