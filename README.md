# FameChecker
 A module created for pokemon essentials that adds the Fame Checker from Fire Red and Leaf Green as an item. While this should be easy to install into your game, there are a few things that need to be noted. I will also have a list of things that I'd like to implement down the line as well. 

Currently, it only works with version 19 or 19.1 or essentials as that is the newest version at the current time, I will most likely update this tool as the version of essentials also updates, possibly supporting older versions along the way.

---
## Installation
 most of installing this tool is drag and drop, all of the files in the Graphics and Plugins can be copied over to the root directory of your install of Pokemon Essentials. you do however need to add this line to your items.txt file within the PBS folder of your Pokemon Essentials install. 
```
634,FAMECHECKER,Fame Checker, Fame Checkers,8,0,"A machine that allows you to see who people are talking about.",2,0,6,
```
please keep in mind that the 634 must be changed to the next number in line in your current items.txt file, the value I have here is just the value expected when booting up a new copy of Pokemon Essentials.

---
## Usage
 The main intention of creating this tool was to make it as easy to use as possible, all of the functions that are specifically made for the game maker will be within the file **7 - gameMakerFunctions.rb**. this file has all the explanation of what functions are used and how to use them. Provided you want to create all of the famous people and info for those people at the beginning of the game, the functions **setupFamousPeople** and **setupFameInfo** are to be used.

 #### Template usage
 ```ruby
def self.setupFamousPeople()
# template
self.createFamousPerson(
    "OAK", # name of famous person
    "OAK.png", # name of big sprite file
    true # deciding if the player has encountered the person in question
)
# can also be in the form of
self.createFamousPerson("DAISY", "DAISY.png", true)
end

def self.setupFameInfo()
# template
self.createFameInfo(
    "OAK", # name of famous person
    "4.png",  # name of small sprite file
    ["VERIDIAN CITY", "GYM SIGN"], # text to display within the box in the middle of the screen
    ["Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"], # text that displays when you press USE
    "Did you hear about his secret experiment...", # the text that'll be displayed when hovering over
    true # deciding if the player has learned this info
)
end
 ```

When giving the player the item, the function call from base Pokemon Essentials will be ``pbReceiveItem(:FAMECHECKER)``. If you at any point want to use the functions ``createFamousPerson`` and ``createFameInfo`` outside of this context it must be written as ``FameChecker.createFamousPerson`` or  ``FameChecker.createFameInfo``, all else being the same.

---
## Future Updates
I have a few things planned in the future of this project which range from improving the code quality to adding even more features.

* [ ] Write a Python script to automate creation of famous people and their info NPCs
* [ ] refactor the entire code base to be more easily maintainable, as it is currently very messy.
* [ ] add a set of game maker functions to make creating fame info for the player character that can change based on the actions of the player

If anybody has any other ideas for this tool, please suggest it in the issues tab, using the label *enchancement*