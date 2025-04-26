require "card"

PILE_TYPE = {
  TABLEAU = 0,
  FOUNDATION = 1,
  WASTE = 2
}

PileClass = {}

-- creates a new pile with the first n cards from the inputted deck (that is, a list of card names). 
-- This function will actually remove those cards from the deck as well.
function PileClass:new(xPos, yPos, type, deck, n, name)
  local pile = {}
  local metadata = {__index = PileClass}
  setmetatable(pile, metadata)

  pile.position = Vector(xPos, yPos)
  pile.type = type
  pile.name = name
  pile.cards = {}

  for i = 1, n do
    table.insert(pile.cards, CardClass:new(xPos, yPos + (type == PILE_TYPE.FOUNDATION and 0 or (i-1)*(24)), deck[1], false, name))
    print(pile.cards[1]:getValue())
    table.remove(deck, 1)
  end

  if pile.type == PILE_TYPE.TABLEAU then pile.cards[#pile.cards]:flip() end

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

function PileClass:push(card)
  if self.type == PILE_TYPE.TABLEAU then
    if math.fmod(self.cards[#self.cards]:getValue(), 13) == math.fmod(card:getValue(), 13) + 1 then
      table.insert(self.cards, card)
      card.position = Vector(self.position.x, self.position.y + (#self.cards-1) * 24)
      return true
    end
  end

  return false
end

-- removes the top card in the pile
function PileClass:pop(numCards)
  for i = 1, numCards do
    if #self.cards > 0 then table.remove(self.cards, #self.cards) end
  end
end

function PileClass:checkForMouseOver()
  local isMouseOver = 
    love.mouse.getX() > self.position.x and
    love.mouse.getX() < self.position.x + CARD_WIDTH*2 and
    love.mouse.getY() > self.position.y and
    love.mouse.getY() < self.position.y + CARD_HEIGHT*2

  if #self.cards > 0 then
    isMouseOver = 
      love.mouse.getX() > self.cards[#self.cards].position.x and
      love.mouse.getX() < self.cards[#self.cards].position.x + self.cards[#self.cards].size.x and
      love.mouse.getY() > self.cards[#self.cards].position.y and
      love.mouse.getY() < self.cards[#self.cards].position.y + self.cards[#self.cards].size.y
  end

  if isMouseOver then 
    return self.name
  else
    return "FALSE"
  end
end
