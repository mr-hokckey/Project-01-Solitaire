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

---

## Project 2 - Solitaire, but better

List of programming patterns used
- Update method - Love2D itself operates on methods called once every frame, so this isn't really a surprise.
- State - Card objects use different states to tell when they're being highlighted, dragged, idle, or unplayable. this made it much easier to program drag and drop.
- Flyweight - All cards have the same appearance when face down, So I have a global variable for the card back sprite that any card can use. it felt wrong to define 52 different card back sprites.
- Singleton - This time around, I believe I correctly implemented the singleton pattern for my deck class, by adding a global instance variable that makes sure there is only one instance of the class at any given moment.

List of people who gave me feedback on my code:
- Ashton - Ashton was the first person to give me advice, and it was before I had submitted Project 1. The main advice he gave me was to make sure I'm including comments in my code. We had an interesting conversation about this, because strangely enough, reading comments in the middle of someone else's code often ends up bothering me more than helping me - they can often be visually distracting to the point that I have a hard time reading the code itself. I personally think it's more helpful to have clean indentation and style to make things easy on the eyes. But while Ashton did say that my code was very readable, having comments is still important to make sure people know what my code does. We agreed that with my programming style, it's best to put comments just before function definitions to keep the comment text out of the way of the actual code, and maybe one or two comments next to individual lines of code that might be confusing. I made sure to do this throughout my entire project. The other advice he gave me was to separate the mouse functions in main.lua, either by integrating them into the card class, or a separate file. I ended up running out of time to do either of these, so I instead created a visual divide in main.lua for the grab-related functions.
- Cal - Cal's main suggestion was to rewrite the update() and push() functions in pile.lua to be more readable. The push() function had a lot of repeated lines of code mixed in with some weird looking lines that, despite being functional, overall looked like a jumbled mess. So I created a helper function for push(), isLegalPush(), which separated things nicely, and made everything less bulky.
- Ronan - Ronan's suggestion was to use for loops when creating cardPiles, since it's a task that seems well suited to a for loop and is pretty bulky. It was a small change, but I agree with it.
- Lastly, the submission comments on my Project 1 pointed out that my deck class wasn't a real singleton because it didn't have a global reference, so I fixed this.

Card Sprites were from here: https://unbent.itch.io/yewbi-playing-card-set-1
Since all the cards were in one png, I ended up writing a Python program to split them into individual files.
Also, I ended up using piskelapp.com to touch up the Ace card sprites, so as to more clearly indicate which suit they are. Additionally, I repurposed the card back sprite to create a reset button sprite and a "YOU WIN!" sprite.

Postmortem

I was very proud of my work on Project 1, and I'm still proud of my work on Project 2, though maybe not quite as much. On one hand, things went pretty smoothly because completing the extra credit points for Project 1 allowed me to skip all of that in Project 2, so I didn't have to add that much. On top of that, my programming style, while being pretty different from my peers, was actually very well received, to the point where I didn't have too many things to act on from feedback. And the things I actually needed to add, I was able to do so in my own personal style.

On the other hand, there are still some organizational things that I kind of would have liked to finish off. Not having a grabber class still doesn't quite sit right with me, and I think the locations of some of the functions and global variables might not make complete sense. My biggest enemy was time, as I've had a lot of work from other classes. At this point, I just have to be glad that I went above and beyond on Project 1, as it made things a lot easier this time around. Even if I don't have time to make my code absolutely perfect, I think I at least made my code very very good.
