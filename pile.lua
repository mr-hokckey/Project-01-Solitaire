-- Pile class for creating piles of cards as objects - tableaus, foundations, and the wastepile.
-- They behave differently depending on the type, and store card objects in a table, but we're
-- mainly interested in their functionality as data structures.

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
    -- table.insert(pile.cards, table.remove(deck, 1))
    table.remove(deck, 1)
  end

  if pile.type == PILE_TYPE.TABLEAU then pile.cards[#pile.cards]:flip() end

  return pile
end

-- function to be called periodically to make sure a pile looks the way it should.
-- This involves things like positioning cards to fan out, flipping the top card of a tableau,
-- and marking certain cards as unplayable according to the rules of the game.
function PileClass:update()
  if self.type == PILE_TYPE.TABLEAU then
    for i, card in ipairs(self.cards) do
      card.position = Vector(self.position.x, self.position.y + (i-1)*24)
    end
    if #self.cards ~= 0 and not self.cards[#self.cards].isFaceUp then
      self.cards[#self.cards]:flip()
    end
    
  elseif self.type == PILE_TYPE.FOUNDATION then
    for _, card in ipairs(self.cards) do
      card.position = Vector(self.position.x, self.position.y)
      card.state = CARD_STATE.UNPLAYABLE
      card.isFaceUp = true
    end
    if #self.cards ~= 0 then self.cards[#self.cards].state = CARD_STATE.IDLE end

  elseif self.type == PILE_TYPE.WASTE then
    for i, card in ipairs(self.cards) do
      card.position = Vector(self.position.x, self.position.y + (i-1)*24)
      card.state = CARD_STATE.UNPLAYABLE
      card.isFaceUp = true
    end
    for i = 2, #self.cards-2 do
      for j = i, #self.cards do
        self.cards[j].position.y = self.cards[j].position.y - 24
      end
    end
    if #self.cards ~= 0 then self.cards[#self.cards].state = CARD_STATE.IDLE end
  end
end

-- just draw a little rectangle where the pile is supposed to be
function PileClass:draw()
  love.graphics.setColor(0, 0.5, 0, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, 64, 96)
end

-- attempt to move a table of cards to another pile, adhering to the rules of the game. 
-- Insert the card at the end of the table,
-- move the card to the proper position, and return true. or return false if unsuccessful.
function PileClass:push(cards)
  if self:isLegalPush(cards) then
    for _, card in ipairs(cards) do
      table.insert(self.cards, card)
      card.location = self.name
    end
    return true
  end

  return false
end

-- new helper function for the refactor. Checks whether or not this is a legal move.
function PileClass:isLegalPush(cards)
  if self.type == PILE_TYPE.TABLEAU then
    return (#self.cards == 0 and math.fmod(cards[1]:getValue(), 13) == 12) or 
    cards[1]:canStackTableau(self.cards[#self.cards])

  elseif self.type == PILE_TYPE.FOUNDATION then
    return (#self.cards == 0 and math.fmod(cards[1]:getValue(), 13) == 0) or
    (#cards == 1 and cards[1]:canStackFoundation(self.cards[#self.cards]))

  -- if we're pushing to the wastepile, we're assuming we're getting these from the deck.
  -- even though this returns true, it is still impossible to drag cards to the wastepile,
  -- since checkForMouseOver() will return false before we even get here.
  elseif self.type == PILE_TYPE.WASTE then
    return true
  end

  return false
end

-- removes the top N cards in the pile
function PileClass:pop(numCards)
  local ret = {}
  for i = 1, numCards do
    if #self.cards > 0 then
      table.insert(ret, table.remove(self.cards))
    end
  end
  return ret
end

-- return T/F if the mouse is in the drop zone for the pile. 
function PileClass:checkForMouseOver()
  local isMouseOver = false

  if self.type == PILE_TYPE.TABLEAU then
    isMouseOver = 
      love.mouse.getX() > self.position.x and
      love.mouse.getX() < self.position.x + 64 and
      love.mouse.getY() > self.position.y + (#self.cards-1) * 24 * self.type and
      love.mouse.getY() < self.position.y + (#self.cards-1) * 24 * self.type + 96
  elseif self.type == PILE_TYPE.FOUNDATION then
    isMouseOver = 
      love.mouse.getX() > self.position.x and
      love.mouse.getX() < self.position.x + 64 and
      love.mouse.getY() > self.position.y and
      love.mouse.getY() < self.position.y + 96
  end

  if isMouseOver then 
    return self.name
  else
    return "FALSE"
  end
end
