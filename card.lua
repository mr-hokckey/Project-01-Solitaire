
require "vector"

cardSuits = {"c", "d", "s", "h"}
cardRanks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K"}

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2,
  UNPLAYABLE = 3
}

CARD_WIDTH = 32
CARD_HEIGHT = 48

cardBackSprite = love.graphics.newImage("Sprites/card_back.png")

function CardClass:new(xPos, yPos, name, isFaceUp, location)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(64, 96)
  card.state = CARD_STATE.IDLE
  card.isFaceUp = isFaceUp
  card.location = location
  card.name = name
  
  card.sprite = love.graphics.newImage("Sprites/" .. name .. ".png")
  
  return card
end

function CardClass:update()
  -- DEBUG --
  if love.keyboard.isDown("o") then
    self.state = CARD_STATE.MOUSE_OVER
  elseif love.keyboard.isDown("g") then
    self.state = CARD_STATE.GRABBED
  else
    self.state = CARD_STATE.IDLE
  end
  -- DEBUG --
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
  love.graphics.print(math.fmod(self:getValue(), 13), self.position.x + self.size.x, self.position.y)
end

function CardClass:checkForMouseOver()
  local isMouseOver = 
    love.mouse.getX() > self.position.x and
    love.mouse.getX() < self.position.x + self.size.x and
    love.mouse.getY() > self.position.y and
    love.mouse.getY() < self.position.y + self.size.y
    
  return isMouseOver and self.isFaceUp
end

function CardClass:flip()
  self.isFaceUp = not self.isFaceUp
end

function CardClass:getValue()
  local val = 0
  local suit = string.sub(self.name, 2, 2)
  local rank = string.sub(self.name, 1, 1)

  for i, s in ipairs(cardSuits) do
    if suit == s then
      val = 13 * (i - 1)
    end
  end

  for i, r in ipairs(cardRanks) do
    if rank == r then
      val = val + (i - 1)
    end
  end

  return val
end

-- return T/F if a card can or cannot be added to a tableau.
function CardClass:canStackTableau(card)
  return 
    math.fmod(self:getValue(), 13) + 1 == math.fmod(card:getValue(), 13) and
    math.fmod(math.floor(self:getValue() / 13), 2) ~= math.fmod(math.floor(card:getValue() / 13), 2)
end

function CardClass:canStackFoundation(card)
  return
    self:getValue() == card:getValue() + 1 and
    math.fmod(self:getValue(), 13) == math.fmod(card:getValue(), 13) + 1
end