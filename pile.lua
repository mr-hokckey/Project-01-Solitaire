require "card"

PILE_TYPE = {
  TABLEAU = 0,
  FOUNDATION = 1,
  WASTE = 2
}

PileClass = {}

function PileClass:new(xPos, yPos, type, deck, n)
  local pile = {}
  local metadata = {__index = PileClass}
  setmetatable(pile, metadata)

  pile.position = Vector(xPos, yPos)
  pile.type = type
  pile.cards = {}

  for i = 1, n do
    table.insert(pile.cards, CardClass:new(xPos, yPos + (i-1)*(24), deck[1], false))
    table.remove(deck, 1)
  end

  pile.cards[#pile.cards]:flip()

  return pile
end

function PileClass:update()
  for _, card in ipairs(self.cards) do
    card:update()
  end
end

function PileClass:draw()
  for _, card in ipairs(self.cards) do
    card:draw()
  end
end

