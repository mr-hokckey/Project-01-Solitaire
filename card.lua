
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

CARD_WIDTH = 32
CARD_HEIGHT = 48

cardBackSprite = love.graphics.newImage("Sprites/card_back.png")

function CardClass:new(xPos, yPos, name, isFaceUp)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(64, 96)
  card.state = CARD_STATE.IDLE
  card.isFaceUp = isFaceUp
  
  card.sprite = love.graphics.newImage("Sprites/" .. name .. ".png")
  
  return card
end

function CardClass:update()
  if love.keyboard.isDown("o") then
    self.state = CARD_STATE.MOUSE_OVER
  elseif love.keyboard.isDown("g") then
    self.state = CARD_STATE.GRABBED
  else
    self.state = CARD_STATE.IDLE
  end
    
  self:checkForMouseOver()
  
end

function CardClass:draw()
  -- NEW: drop shadow for non-idle cards
  if self.state ~= CARD_STATE.IDLE then
    love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.draw(self.sprite, self.position.x + offset, self.position.y + offset, 0, self.size.x / CARD_WIDTH, self.size.y / CARD_HEIGHT)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  if self.isFaceUp then
    love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, self.size.x / CARD_WIDTH, self.size.y / CARD_HEIGHT)
  else
    love.graphics.draw(cardBackSprite, self.position.x, self.position.y, 0, self.size.x / CARD_WIDTH, self.size.y / CARD_HEIGHT)
  end
end

function CardClass:checkForMouseOver()
  local isMouseOver = 
    love.mouse.getX() > self.position.x and
    love.mouse.getX() < self.position.x + self.size.x and
    love.mouse.getY() > self.position.y and
    love.mouse.getY() < self.position.y + self.size.y
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

function CardClass:flip()
  self.isFaceUp = not self.isFaceUp
end
