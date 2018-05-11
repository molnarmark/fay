# Fay
Work in progress Unit testing library for Multi Theft Auto

## Example
```lua
Fay {
  it("should check if Fay is working correctly", function(sertify)
    local ped = createPed(310, 5, 10, 15)
    sertify:expect(5):toBe(5)
    sertify:expect({1, 2, 3}):atIndex(2):toBe(5)
    sertify:expect(ped):toBeAnElement()
  end)
}
```
