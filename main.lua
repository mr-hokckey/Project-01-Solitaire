-- Leo Assimes
-- CMPM-121 - Project 1 - Solitaire
-- 4/18/2025

-- Card Sprites: https://unbent.itch.io/yewbi-playing-card-set-1
-- Since all the cards were in one png, I ended up writing a Python program to split them into individual files.

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
  
  cardDeck = DeckClass:new()
  -- cardDeck:shuffleDeck()
  
  
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_1.x, PILE_POSITIONS.TABLEAU_1.y, cardDeck[1], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_2.x, PILE_POSITIONS.TABLEAU_2.y, cardDeck[2], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_3.x, PILE_POSITIONS.TABLEAU_3.y, cardDeck[3], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_4.x, PILE_POSITIONS.TABLEAU_4.y, cardDeck[4], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_5.x, PILE_POSITIONS.TABLEAU_5.y, cardDeck[5], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_6.x, PILE_POSITIONS.TABLEAU_6.y, cardDeck[6], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_7.x, PILE_POSITIONS.TABLEAU_7.y, cardDeck[7], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.STOCK.x, PILE_POSITIONS.STOCK.y, cardDeck[8], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.WASTE.x, PILE_POSITIONS.WASTE.y, cardDeck[9], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.FOUNDATION_1.x, PILE_POSITIONS.FOUNDATION_1.y, cardDeck[10], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.FOUNDATION_2.x, PILE_POSITIONS.FOUNDATION_2.y, cardDeck[10], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.FOUNDATION_3.x, PILE_POSITIONS.FOUNDATION_3.y, cardDeck[10], false))
  -- table.insert(cardTable, CardClass:new(PILE_POSITIONS.FOUNDATION_4.x, PILE_POSITIONS.FOUNDATION_4.y, cardDeck[10], false))
  
  -- for i=1, 19 do
  --   table.insert(cardTable, CardClass:new(PILE_POSITIONS.TABLEAU_7.x, PILE_POSITIONS.TABLEAU_7.y + (i-1)*(24), cardDeck[i], false))
  -- end
  
  -- tableau = PileClass:new(PILE_POSITIONS.TABLEAU_1.x, PILE_POSITIONS.TABLEAU_1.y, PILE_TYPE.TABLEAU, { cardDeck[1] } )

  cardPiles = {
    PileClass:new(PILE_POSITIONS.TABLEAU_1.x, PILE_POSITIONS.TABLEAU_1.y, PILE_TYPE.TABLEAU, cardDeck.cards, 1),
    PileClass:new(PILE_POSITIONS.TABLEAU_2.x, PILE_POSITIONS.TABLEAU_2.y, PILE_TYPE.TABLEAU, cardDeck.cards, 2),
    PileClass:new(PILE_POSITIONS.TABLEAU_3.x, PILE_POSITIONS.TABLEAU_3.y, PILE_TYPE.TABLEAU, cardDeck.cards, 3),
    PileClass:new(PILE_POSITIONS.TABLEAU_4.x, PILE_POSITIONS.TABLEAU_4.y, PILE_TYPE.TABLEAU, cardDeck.cards, 4),
    PileClass:new(PILE_POSITIONS.TABLEAU_5.x, PILE_POSITIONS.TABLEAU_5.y, PILE_TYPE.TABLEAU, cardDeck.cards, 5),
    PileClass:new(PILE_POSITIONS.TABLEAU_6.x, PILE_POSITIONS.TABLEAU_6.y, PILE_TYPE.TABLEAU, cardDeck.cards, 6),
    PileClass:new(PILE_POSITIONS.TABLEAU_7.x, PILE_POSITIONS.TABLEAU_7.y, PILE_TYPE.TABLEAU, cardDeck.cards, 7)
  }

end

function love.update()
  selectedCard = nil
  
  for _, pile in ipairs(cardPiles) do
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
    releaseCard()
  end
  
  if #grabbedCards ~= 0 then
    for i, card in ipairs(grabbedCards) do
      card.state = CARD_STATE.GRABBED
      card.position = Vector(love.mouse.getX(), love.mouse.getY()) - grabOffset[i]
    end
  end

end

function love.draw()
  for _, pile in ipairs(cardPiles) do
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

  -- tableau:draw()
end

function love.keypressed(key)
  if key == "f" then
    for _, pile in ipairs(cardPiles) do
      for _, card in ipairs(pile.cards) do
        card:flip()
      end
    end
  end
end

function grabCards()
  if selectedCard ~= nil then
    selectedCard.state = CARD_STATE.GRABBED
    table.insert(grabbedCards, selectedCard)
    table.insert(grabPos, selectedCard.position)
    table.insert(grabOffset, Vector(love.mouse.getX() - selectedCard.position.x, love.mouse.getY() - selectedCard.position.y))
  end
end

function releaseCard()
  for i, card in ipairs(grabbedCards) do
    card.state = CARD_STATE.MOUSE_OVER
    card.position = grabPos[i]
  end
  grabbedCards = {}
  grabPos = {}
  grabOffset = {}
end
