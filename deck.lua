
DeckClass = {}

cardSuits = {"c", "d", "h", "s"}
cardRanks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K"}

function DeckClass:new()
  local deck = {}
  local metadata = {__index = DeckClass}
  setmetatable(deck, metadata)
  
  for _, s in ipairs(cardSuits) do
    for _, r in ipairs(cardRanks) do
      table.insert(deck, r .. s)
    end
  end
  return deck
end

function DeckClass:shuffle()
	local cardCount = #self
	for i = 1, cardCount do
		local randIndex = math.random(cardCount)
    local temp = self[randIndex]
    self[randIndex] = self[cardCount]
    self[cardCount] = temp
    cardCount = cardCount - 1
	end
  for i = 1, cardCount do
    print(self[i])
  end
end
