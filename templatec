#!/usr/bin/env lua
local template = require "template"
local i = 1
local minify = false
while i <= #arg do
  if arg[i] == "-o" then
    i = i + 1
    io.output(arg[i])
  elseif arg[i] == "-m" then
    minify = true
  else
    io.input(arg[i])
  end
  i = i + 1
end
io.write(template.parse(io.read("*a"), minify))
