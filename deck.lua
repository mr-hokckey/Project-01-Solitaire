-- A deck of cards class, which will also double as the stock pile.

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

function DeckClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(cardBackSprite, self.position.x, self.position.y, 0, self.size.x / CARD_WIDTH, self.size.y / CARD_HEIGHT)
end
