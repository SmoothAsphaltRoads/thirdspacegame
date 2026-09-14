# Purpose of this doc:
This is essentially a way to keep track of who is doing what, and what needs to be done.

# Things done so far
- basic player movement
- collisions
- a singular level
- main menu (bg music and bg image to be chosen)

# To do
- Art ( save this one for later maybe)
- Ui (menu's, cutscenes, etc)
    - Ill try nd figure out a way to do this, never done it before (harish)
- Level manager (a way to handle progression and stuff) 
- Sounds (again, save this for later)
- Content ( will do after the main game is done)
- Enemies 
- Different Puzzle elements

# Project structure
- everything has 2 components to it, a scene and a script. 
- the scenes go in scenes/ and the scripts go into scripts/
- under scenes/, every level has its own scenes, that bundles together a player instance, an enemy instance, whatever.
- the level manager scripts is auto loaded, its global, it can be called from anywhere.
- the level manager provides an interface to handle progression, next/prev level, restart, keep global scores, etc ect
- level changes are called when needed inside the player script
- there is a global transition scene which can be called when needed from anywhere, right now only the level manager uses it
