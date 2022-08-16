# FameChecker
 A module created for pokemon essentials that adds the Fame Checker from Fire Red and Leaf Green as an item. While this should be easy to install into your game, there are a few things that need to be noted. I will also have a list of things that I'd like to implement down the line as well. 

 for v20/v20.1 please go to [this fork](https://github.com/domx9200/FameChecker)

---
## Installation
 most of installing this tool is drag and drop, all of the files in the Graphics and Plugins can be copied over to the root directory of your install of Pokemon Essentials. you do however need to add this line to your items.txt file within the PBS folder of your Pokemon Essentials install. 
```
634,FAMECHECKER,Fame Checker, Fame Checkers,8,0,"A machine that allows you to see who people are talking about.",2,0,6,
```
please keep in mind that the 634 must be changed to a number that isn't in use by your items.txt file, the value I have here is just the value expected when booting up a new copy of Pokemon Essentials.

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

When giving the player the item, the function call from base Pokemon Essentials will be ``pbReceiveItem(:FAMECHECKER)``. If you at any point want to use the functions ``createFamousPerson()`` and ``createFameInfo()`` outside of this context it must be written as ``FameChecker.createFamousPerson()`` or  ``FameChecker.createFameInfo()``, all else being the same. 

If you don't want to use the item and would rather use it in a difference context, such as during a conversation or in another plugin, all you need to do is call the function ``FameChecker.create()``, this function was originally intended to be an internal function only, but it was brought to my attention that people want to use it in different contexts, Depending on feedback, I might rename this function when I work on the re-write to be more accurate to what it does.

additionally, there are a few functions that you want to be using when scripting for NPC's. ``FameChecker.hasEncountered()`` is the function you want to use to set if the player has encountered a specific famous person and ``FameChecker.hasFoundInfo()`` is the function you want to use to set if the player knows a specific bit of information. I encourage you to look at ``7 - gameMakerFunctions`` for more information.

#### code representing these functions
```ruby
def self.hasEncountered(famousPersonName, hasMet = true)
  FameChecker.checkSetup
  FameChecker.runSetup

  if !$PokemonGlobal.FameTargets[famousPersonName]
    print("name input doesn't exist")
    return
  end
  $PokemonGlobal.FameTargets[famousPersonName]["seen"] = hasMet
end

def self.hasFoundInfo(famousPersonName, infoNum, hasFound = true)
  FameChecker.checkSetup
  FameChecker.runSetup

  if !$PokemonGlobal.FameTargets[famousPersonName]
    print("name input doesn't exist")
    return
  end

  if !$PokemonGlobal.FameInfo[famousPersonName][infoNum]
    print("the number you input for the info of #{famousPersonName} doesn't exist.")
  end
  $PokemonGlobal.FameInfo[famousPersonName][infoNum]["seen"] = hasFound
end
```

#### images showing usage
![how to use FameChecker.hasEncountered](https://raw.githubusercontent.com/domx9200/FameChecker/main/screenshot.5.jpg)
![how to use FameChecker.hadFoundInfo](https://raw.githubusercontent.com/domx9200/FameChecker/main/screenshot.6.jpg)
