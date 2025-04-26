require "card"

PILE_TYPE = {
  FOUNDATION = 0,
  TABLEAU = 1,
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
  love.graphics.setColor(0, 0.5, 0, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, 64, 96)
  love.graphics.print(self:checkForMouseOver(), self.position.x, self.position.y - 20)
end

function PileClass:push(card)
  if self.type == PILE_TYPE.TABLEAU then
    if #self.cards == 0 then
      if math.fmod(card:getValue(), 13) == 12 then
        table.insert(self.cards, card)
        card.position = Vector(self.position.x, self.position.y + (#self.cards-1) * 24)
        return true
      end
    elseif card:canStackTableau(self.cards[#self.cards]) then
      table.insert(self.cards, card)
      card.position = Vector(self.position.x, self.position.y + (#self.cards-1) * 24)
      return true
    end
  elseif self.type == PILE_TYPE.FOUNDATION then
    if #self.cards == 0 then
      if math.fmod(card:getValue(), 13) == 0 then
        table.insert(self.cards, card)
        card.position = Vector(self.position.x, self.position.y)
        return true
      end
    elseif card:canStackFoundation(self.cards[#self.cards]) then
      table.insert(self.cards, card)
      card.position = Vector(self.position.x, self.position.y)
      return true
    end
  end

  return false
end

-- removes the top card in the pile
function PileClass:pop(numCards)
  local ret = {}
  for i = 1, numCards do
    if #self.cards > 0 then
      table.insert(ret, table.remove(self.cards))
    end
  end
  return ret
end

function PileClass:checkForMouseOver()
  local isMouseOver = 
    love.mouse.getX() > self.position.x and
    love.mouse.getX() < self.position.x + 64 and
    love.mouse.getY() > self.position.y + (#self.cards-1) * 24 * self.type and
    love.mouse.getY() < self.position.y + (#self.cards-1) * 24 * self.type + 96
    
  if self.type == PILE_TYPE.FOUNDATION then
    isMouseOver = 
      love.mouse.getX() > self.position.x and
      love.mouse.getX() < self.position.x + 64 and
      love.mouse.getY() > self.position.y and
      love.mouse.getY() < self.position.y + 96
  end
  

  -- because you can't drag something to the wastepile
  if isMouseOver and self.type ~= PILE_TYPE.WASTE then 
    return self.name
  else
    return "FALSE"
  end
end
