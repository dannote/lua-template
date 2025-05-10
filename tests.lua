require 'busted.runner'()

describe("template module", function()
  local template = require('template')

  describe("template processing", function()
    it("processes simple template", function()
      local func = template.compile("Hello, <%= name %>!")
      local output = {}
      template.print(func, { name = "World" }, function(s) table.insert(output, s) end)
      assert.equal("Hello, World!", table.concat(output, ""))
    end)

    it("processes conditional template", function()
      local func = template.compile("<? if name then ?>Hello, <%= name %>!<? else ?>Guest<? end ?>")
      local output = {}
      template.print(func, { name = "World" }, function(s) table.insert(output, s) end)
      assert.equal("Hello, World!", table.concat(output, ""))
    end)

    it("errors on invalid template", function()
      assert.has_error(function()
        template.compile("<%= ) %>")
      end)
    end)
  end)
end)
