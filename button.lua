
ButtonClass = {}

function ButtonClass:new(xPos, yPos, sprite)
  local button = {}
  local metadata = {__index = ButtonClass}
  setmetatable(button, metadata)

  button.position = Vector(xPos, yPos)
  button.sprite = sprite
  return button
end

function ButtonClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, 2, 2)  
end

function ButtonClass:checkForMouseOver()
  local isMouseOver = 
    love.mouse.getX() > self.position.x and
    love.mouse.getX() < self.position.x + 96 and
    love.mouse.getY() > self.position.y and
    love.mouse.getY() < self.position.y + 64
  
  return isMouseOver
end