Card Sprites: https://unbent.itch.io/yewbi-playing-card-set-1
Since all the cards were in one png, I ended up writing a Python program to split them into individual files.

List of programming patterns used
- Update method - Love2D itself operates on methods called once every frame, so this isn't really a surprise.
- State - Card objects use different states to tell when they're being highlighted, dragged, idle, or unplayable. this made it much easier to program drag and drop.
- Flyweight - All cards have the same appearance when face down, So I have a global variable for the card back sprite that any card can use. it felt wrong to define 52 different card back sprites.
- Singleton - I have a deck class, of which there is exactly one instance. It's really just a table full of card names with some extra functionality, but as I went through the project I decided I might as well make it a class.

Postmortem 

I'm honestly very happy with all of my work, even if I had to take some extra time. When I started the assignment, I had mentally committed to programming the game just as Google has it, and already had ideas for how to make that happen. Only halfway through the assignment did I realize that a solid half of what I was doing probably wasn't necessary, but I decided to keep going with it because I was already committed to it. A part of me wishes I had read the assignment properly the first time just to save myself the workload, but it's hard to say I have any regrets.

My programming style is also something I'm very proud of. I think I'm very good at making things as simple as possible overall, while also finding creative solutions to unusual problems. I designed a lot of the game objects in a way that made things easier to program and understand. But I do think there are some inconsistencies here and there. I think it's a little weird having all the different piles be represented by a pile object, EXCEPT the stock pile. Even with the different functionalities that each kind of pile requires, I think there was definitely a way to create a pile object that could be more versatile and more efficient with storage of information. Maybe some sort of Type Object pattern? Or possibly just better use of the Flyweight pattern. If not for robustness, at least for readability.

Additionally, I definitely think I should have made a grabber class. I decided not to make a grabber class because I  thought it was causing bugs when I was working on it during discussion section, but after seeing other people's code, I might be wrong about that. It would have been another use of the Singleton pattern, which I think makes sense.