local function Sertify(fayInstance, testInfo)
  return {
    expect = function(self, initialValue)
      return {
        toBe = function(self, right)
          return fayInstance.Reporter.Report(initialValue == right, testInfo)
        end,
      }
    end
  }
end

local function Fay(tests)
  local this = {
    Reporter = {
      Report = function(assertion, testInfo)
        if assertion then
          outputChatBox(testInfo.description .. " passed")
        else
          outputChatBox(testInfo.description .. " failed")
        end
      end
    }
  }

  for _, testData in pairs(tests) do
    testData.fun(Sertify(this, {
      description = testData.description
    }))
  end
end

local function it(description, callback)
  return {
    description = description,
    fun = function(sertify)
      return callback(sertify)
    end
  }
end

Fay {
  it("should pass", function(sertify)
    sertify:expect(5):toBe(5)
  end),

  it("should not pass", function(sertify)
    sertify:expect(4):toBe(5)
  end)
}