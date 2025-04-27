-- Leo Assimes
-- CMPM-121 - Project 1 - Solitaire
-- 4/18/2025

-- main class - this class handles drag-and-drop functionality and interactions between different classes.
-- I decided not to make a grabber class because I thought it was causing bugs when I was working on it
-- during discussion section. I might have been wrong though.

io.stdout:setvbuf("no")

love.graphics.setDefaultFilter("nearest", "nearest")

require "vector"
require "card"
require "deck"
require "pile"

selectedCard = nil
grabbedCards = {}
grabPos = {}
grabOffset = {}

function love.load()
  screenWidth = 960
  screenHeight = 640
  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setBackgroundColor(0, 0.68, 0.26, 1)
  
  PILE_POSITIONS = {
    STOCK =        Vector(screenWidth*1/8 - 48, screenHeight*1/5 - 48),
    WASTE =        Vector(screenWidth*1/8 - 48, screenHeight*2/5 - 48),
    TABLEAU_1 =    Vector(screenWidth*3/12 - 32, 56),
    TABLEAU_2 =    Vector(screenWidth*4/12 - 32, 56),
    TABLEAU_3 =    Vector(screenWidth*5/12 - 32, 56),
    TABLEAU_4 =    Vector(screenWidth*6/12 - 32, 56),
    TABLEAU_5 =    Vector(screenWidth*7/12 - 32, 56),
    TABLEAU_6 =    Vector(screenWidth*8/12 - 32, 56),
    TABLEAU_7 =    Vector(screenWidth*9/12 - 32, 56),
    FOUNDATION_1 = Vector(screenWidth*7/8 - 16, screenHeight*1/5 - 48),
    FOUNDATION_2 = Vector(screenWidth*7/8 - 16, screenHeight*2/5 - 48),
    FOUNDATION_3 = Vector(screenWidth*7/8 - 16, screenHeight*3/5 - 48),
    FOUNDATION_4 = Vector(screenWidth*7/8 - 16, screenHeight*4/5 - 48)
  }
  
  math.randomseed(os.time())
  
  -- create a card deck object and shuffle it with a random seed.
  cardDeck = DeckClass:new(PILE_POSITIONS.STOCK.x, PILE_POSITIONS.STOCK.y)
  cardDeck:shuffleDeck()

  cardPiles = {
    ["TABLEAU_1"] = PileClass:new(PILE_POSITIONS.TABLEAU_1.x, PILE_POSITIONS.TABLEAU_1.y, PILE_TYPE.TABLEAU, cardDeck.cards, 1, "TABLEAU_1"),
    ["TABLEAU_2"] = PileClass:new(PILE_POSITIONS.TABLEAU_2.x, PILE_POSITIONS.TABLEAU_2.y, PILE_TYPE.TABLEAU, cardDeck.cards, 2, "TABLEAU_2"),
    ["TABLEAU_3"] = PileClass:new(PILE_POSITIONS.TABLEAU_3.x, PILE_POSITIONS.TABLEAU_3.y, PILE_TYPE.TABLEAU, cardDeck.cards, 3, "TABLEAU_3"),
    ["TABLEAU_4"] = PileClass:new(PILE_POSITIONS.TABLEAU_4.x, PILE_POSITIONS.TABLEAU_4.y, PILE_TYPE.TABLEAU, cardDeck.cards, 4, "TABLEAU_4"),
    ["TABLEAU_5"] = PileClass:new(PILE_POSITIONS.TABLEAU_5.x, PILE_POSITIONS.TABLEAU_5.y, PILE_TYPE.TABLEAU, cardDeck.cards, 5, "TABLEAU_5"),
    ["TABLEAU_6"] = PileClass:new(PILE_POSITIONS.TABLEAU_6.x, PILE_POSITIONS.TABLEAU_6.y, PILE_TYPE.TABLEAU, cardDeck.cards, 6, "TABLEAU_6"),
    ["TABLEAU_7"] = PileClass:new(PILE_POSITIONS.TABLEAU_7.x, PILE_POSITIONS.TABLEAU_7.y, PILE_TYPE.TABLEAU, cardDeck.cards, 7, "TABLEAU_7"),
    ["FOUNDATION_1"] = PileClass:new(PILE_POSITIONS.FOUNDATION_1.x, PILE_POSITIONS.FOUNDATION_1.y, PILE_TYPE.FOUNDATION, cardDeck.cards, 0, "FOUNDATION_1"),
    ["FOUNDATION_2"] = PileClass:new(PILE_POSITIONS.FOUNDATION_2.x, PILE_POSITIONS.FOUNDATION_2.y, PILE_TYPE.FOUNDATION, cardDeck.cards, 0, "FOUNDATION_2"),
    ["FOUNDATION_3"] = PileClass:new(PILE_POSITIONS.FOUNDATION_3.x, PILE_POSITIONS.FOUNDATION_3.y, PILE_TYPE.FOUNDATION, cardDeck.cards, 0, "FOUNDATION_3"),
    ["FOUNDATION_4"] = PileClass:new(PILE_POSITIONS.FOUNDATION_4.x, PILE_POSITIONS.FOUNDATION_4.y, PILE_TYPE.FOUNDATION, cardDeck.cards, 0, "FOUNDATION_4"),
    ["WASTE"] = PileClass:new(PILE_POSITIONS.WASTE.x, PILE_POSITIONS.WASTE.y, PILE_TYPE.WASTE, cardDeck.cards, 0, "WASTE"),
  }

end

-- love.update() - call update() and checkForMouseOver() on each of the cards, but only one card
-- can actually be highlighted. Also handle grabbing and releasing cards.
function love.update()
  selectedCard = nil
  
  for _, pile in pairs(cardPiles) do
    for _, card in ipairs(pile.cards) do
      card:update()
      if card:checkForMouseOver() then
        selectedCard = card
      end
    end
  end
  
  if selectedCard then 
    selectedCard.state = CARD_STATE.MOUSE_OVER
  end
  
  if #grabbedCards == 0 and love.mouse.isDown(1) then
    grabCards()
  end
  
  if not love.mouse.isDown(1) and #grabbedCards ~= 0 then
    releaseCards()
  end
  
  if #grabbedCards ~= 0 then
    for i, card in ipairs(grabbedCards) do
      card.state = CARD_STATE.GRABBED
      card.position = Vector(love.mouse.getX(), love.mouse.getY()) - grabOffset[i]
    end
  end

end

-- Draw each of the cards and piles. Drawing them in order makes sure they fan out smoothly like they would in real life.
-- However, drawing the grabbedCards AGAIN makes them appear on top of everything else!
function love.draw()
  cardDeck:draw()
  
  for _, pile in pairs(cardPiles) do
    pile:draw()
    for _, card in ipairs(pile.cards) do
      card:draw()
    end
  end
  -- Love2D doesn't have support for z-ordering, but we can do this instead!
  if #grabbedCards ~= 0 then 
    for _, card in ipairs(grabbedCards) do
      card:draw()
    end
  end
end

-- click on the deck to draw 3 cards from the deck. Those strings are removed from the deck and used in new card objects.
-- The math also accounts for when there are less than 3 cards left in the deck.
function love.mousepressed(xPos, yPos, button)
  if button == 1 and cardDeck:checkForMouseOver() then
    if #cardDeck.cards == 0 then
      for _, card in ipairs(cardPiles["WASTE"].cards) do
        table.insert(cardDeck.cards, card.name)
      end
      cardPiles["WASTE"].cards = {}
    else
      for _ = 1, 3 do
        if #cardDeck.cards ~= 0 then
          cardPiles["WASTE"]:push({CardClass:new(0, 0, cardDeck.cards[1], true, "WASTE")})
          table.remove(cardDeck.cards, 1)
        end
      end
    end
    cardPiles["WASTE"]:update()
  end
end

-- Grab the selected card if it exists. Then, find out if that card is in a tableau, and
-- grab all the cards below it if so.
function grabCards()
  if selectedCard ~= nil then
    selectedCard.state = CARD_STATE.GRABBED
    table.insert(grabbedCards, selectedCard)
    table.insert(grabPos, selectedCard.position)
    table.insert(grabOffset, Vector(love.mouse.getX() - selectedCard.position.x, love.mouse.getY() - selectedCard.position.y))

    local srcPile = selectedCard.location
    if cardPiles[srcPile].type == PILE_TYPE.TABLEAU then
      local cardIndex = 1
      for i, card in ipairs(cardPiles[srcPile].cards) do
        if card.name == selectedCard.name then
          cardIndex = i
          break
        end
      end

      for i = cardIndex + 1, #cardPiles[srcPile].cards do
        table.insert(grabbedCards, cardPiles[srcPile].cards[i])
        table.insert(grabPos, cardPiles[srcPile].cards[i].position)
        table.insert(grabOffset, Vector(love.mouse.getX() - cardPiles[srcPile].cards[i].position.x, love.mouse.getY() - cardPiles[srcPile].cards[i].position.y))
      end
    end
  end
end

-- upon releasing cards, check if we're hovering over a pile, and check if they can be added. Add them if so.
function releaseCards()
  local src = grabbedCards[1].location
  local dst = "FALSE"
  for _, pile in pairs(cardPiles) do
    dst = pile:checkForMouseOver()
    if dst ~= "FALSE" then
      break
    end
  end

  if dst ~= "FALSE" and cardPiles[dst]:push(grabbedCards) then
    cardPiles[src]:pop(#grabbedCards)
    cardPiles[dst]:update()
  end
  cardPiles[src]:update()
  grabbedCards = {}
  grabPos = {}
  grabOffset = {}
end
