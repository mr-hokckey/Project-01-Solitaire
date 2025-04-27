-- A deck of cards class, which will also double as the stock pile.
-- This one works differently from the pile class. Instead of storing
-- Card objects, we just store a list of strings for card names.

require "card"

DeckClass = {}

function DeckClass:new(xPos, yPos)
  local deck = {}
  local metadata = {__index = DeckClass}
  setmetatable(deck, metadata)

  deck.position = Vector(xPos, yPos)
  deck.size = Vector(64, 96)
  deck.cards = {}
  
  for _, s in ipairs(cardSuits) do
    for _, r in ipairs(cardRanks) do
      table.insert(deck.cards, r .. s)
    end
  end
  return deck
end

-- Shuffle the deck using Fisher-Yates.
function DeckClass:shuffleDeck()
	local cardCount = #self.cards
	for i = 1, cardCount do
		local randIndex = math.random(cardCount)
    local temp = self.cards[randIndex]
    self.cards[randIndex] = self.cards[cardCount]
    self.cards[cardCount] = temp
    cardCount = cardCount - 1
	end
  for i = 1, cardCount do
    print(self.cards[i])
  end
end

-- Just draw a green rectangle and a card back sprite, for the visuals.
function DeckClass:draw()
  love.graphics.setColor(0, 0.5, 0, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, 64, 96)
  if #self.cards ~= 0 then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(cardBackSprite, self.position.x, self.position.y, 0, self.size.x / CARD_WIDTH, self.size.y / CARD_HEIGHT)  
  end
end

function DeckClass:checkForMouseOver()
  local isMouseOver = 
    love.mouse.getX() > self.position.x and
    love.mouse.getX() < self.position.x + 64 and
    love.mouse.getY() > self.position.y and
    love.mouse.getY() < self.position.y + 96
  
  return isMouseOver
end