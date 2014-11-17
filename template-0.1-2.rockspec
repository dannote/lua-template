package = "template"
version = "0.1-2"

source = {
  url = "git://github.com/dannote/lua-template.git"
}

description = {
  summary = "The simplest Lua template engine in just a few lines of code",
  homepage = "https://github.com/dannote/lua-template",
  maintainer = "Danila Poyarkov <dannotemail@gmail.com>",
  license = "MIT"
}

dependencies = {
  "lua >= 5.0"
}

build = {
  type = "builtin",
  modules = {
    ["template"] = "template.lua"
  },
  install = {
    bin = {"templatec"}
  }
}