# FameChecker

A module created for pokemon essentials that adds the Fame Checker from Fire Red and Leaf Green as an item. While this should be easy to install into your game, there are a few things that need to be noted.

## Currently, I have a working version for versions 19, 19.1, 20, and 20.1. I will be maintaining all versions I create until they are 3 versions old, as such v19 will be deprecated as of v22 and v20 will be deprecated as of v23. to get to the README for v19 and v19.1 swap to [this fork](https://github.com/domx9200/FameChecker/tree/Essentials-v19)

## Installation

most of installing this tool is drag and drop, all of the files in the Graphics PBS, and Plugins can be copied over to the root directory of your install of Pokemon Essentials. you do however need to add this line to your items.txt file within the PBS folder of your Pokemon Essentials install.

### NOTE: Please ensure that you delete previous versions if you are updating.

```
#-------------------------------
[FAMECHECKER]
Name = Fame Checker
NamePlural = Fame Checkers
Pocket = 8
Price = 0
FieldUse = Direct
Flags = KeyItem
Description = A machine that allows you to see who people are talking about.
```

---

## Usage

The main intention of creating this tool was to make it as easy to use as possible, all of the functions that are specifically made for the game maker will be within the **userFunctions.rb** file. This file has all the explanation of what functions are used and how to use them. Inputting famous people and their respective info is now done through a PBS file in the same style of v20 Essentials. A list of all options will be below

If you intend to use the built in item, to give the item to the player use `pbRecieveItem(:FAMECHECKER)`. If you instead intend to use the system without the item, please call the function `FameChecker.startFameChecker()`, this replaced the original FameChecker.create() of older versions.

If you want to modify if a person or piece of info has been seen, please use the functions `FameChecker.setFameSeen()` for setting famous people, and `FameChecker.setFameInfoSeen()` for setting a piece of info for a famous person.

```ruby
# FameChecker.setFameSeen
# famousPerson => Symbol, is the name of the famous person
# seen => boolean, defaults to true, is the value it's HasBeenSeen will become
def self.setFameSeen(famousPerson, seen = true)

# FameChecker.setFameInfoSeen
# famousPerson => Symbol, is the name of the famous person
# info => Symbol or Integer, represents either the position within the FameInfo array, or the Symbol that was given on compile time
# seen => boolean, defaults to true, is the value it's HasBeenSeen will become
def self.setFameInfoSeen(famousPerson, info, seen = true)
```

For looking at the HasBeenSeen value of a famous person or piece of info, please use the functions `FameChecker.fameStatus?()` for famous people, and `FameChecker.infoStatus?()` for a piece of info.

```ruby
# FameChecker.fameStatus?
# famousPerson => Symbol, is the name of the famous person
def self.fameStatus?(famousPerson)

# FameChecker.infoStatus?
# famousPerson => Symbol, is the name of the famous person
# info => Symbol or Integer, represents either the position within the FameInfo array, or the Symbol that was given on compile time
def self.infoStatus?(famousPerson, info)
```

additionaly, I have created a game switch with the default value of 2765. you can access it through `FameChecker.FAME_SWITCH`. If you want to modify this value, you can do so within **userFunctions.rb**.

### Inputting PBS Information

There is a bunch of different elements to talk about when it comes to inputting information.
Below is a table containing every possible element that you can input, below that is an example of input.

#### Input for famous people

|             Element             |  Inputs  | Required |     Default     |                                                                                                     Explanation                                                                                                     |
| :-----------------------------: | :------: | :------: | :-------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|             [input]             |  String  |   Yes    |       N/A       |                            This must be included to being input of a new famous person, failing to include one that is unique reaults in data being overwritten, or the program crashing                            |
|              Name               |  String  |    No    | same as [input] |                                                  Both [input] must exist, Name =, is only for when you want the internal name to be different from the Symbol name                                                  |
|           HasBeenSeen           | Boolean  |    No    |      False      |                                                                                                         N/A                                                                                                         |
|         SpriteLocation          |  String  |   Yes    |       N/A       |                                                                                If there is no device sprite, the program will crash                                                                                 |
|          SpriteOffset           | Int, Int |    No    |      0, 0       |                                                                                   Modifies the position of the device sprite x, y                                                                                   |
| FameInfo = {<br>info input<br>} |   N/A    |    No    |       N/A       | This is not required if you don't have any bits of info, but is absolutely necessary for including any bits of info. make sure that FameInfo = { is the only thing on its line, and } is the only thing on its line |

#### input for bits of info

|     Element      |           Inputs           | Required |                                                                     Default                                                                      |                                                                          Explanation                                                                          |
| :--------------: | :------------------------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------: |
|     [input]      |           String           |   Yes    |                                                                       N/A                                                                        | This must be included to being input of a new piece of info, failing to include one that is unique reaults in data being overwritten, or the program crashing |
|  SpriteLocation  |           String           |   Yes    |                                                                       N/A                                                                        |                                                      If there is no info sprite, the program will crash                                                       |
|   HasBeenSeen    |          Boolean           |    No    |                                                                      False                                                                       |                                                                              N/A                                                                              |
|    IsAnimated    |          Boolean           |    No    |                                                                      False                                                                       |                         Represents if the input element is animated or not, this informs the default for a lot of the other elements                          |
|      Frames      |        Positive Int        |    No    |                                                                     0 or 16                                                                      |                                                              0 if IsAnimated = false, 16 if true                                                              |
|   FramesToShow   | Positive Int, Positive Int |    No    |                                                                 [0, 0] or [0, 3]                                                                 |                                                           0, 0 if IsAnimated = false, 0, 3 if true                                                            |
|    FrameSkip     |        Positive Int        |    No    |                                                                      0 or 4                                                                      |                                                              0 if IsAnimated = false, 4 if true                                                               |
|    FrameSize     | Positive Int, Positive Int |    No    | [Size of SpriteLocation / sqrt(Frames).ceil(), Size of SpriteLocation / sqrt(Frames).ceil()] or [size of SpriteLocation, size of SpriteLocation] |                                             is full image if IsAnimated = false, calculates a frame size if true                                              |
| MiddleScreenText |       String, String       |    No    |                                                                      "",""                                                                       |                                                  If you want to include , into text, make sure to use quotes                                                  |
|    HoverText     |           String           |    No    |                                                                        ""                                                                        |                                                   HoverText doesn't need to be in quotes, even if you use ,                                                   |
|    SelectText    |   any number of Strings    |    No    |                                                                       [""]                                                                       |                                                  If you want to include , into text, make sure to use quotes                                                  |

provided that your sprite for a piece of fame info is a normal overworld sprite (16 frames total, equal size frames, down facing is the first 4 frames), if you want it animated, all you need to do is IsAnimated = true, the rest is automatically figured out.

#### Example PBS Input

```
[OAK]
Name = Oak
HasBeenSeen = true
SpriteLocation = Graphics/Pictures/FameChecker/DeviceSprites/OAK.png
SpriteOffset = -2, 0
FameInfo = {
	[EXPERIMENT]
	SpriteLocation = Graphics/Pictures/FameChecker/SmallSprites/GymSign.png
	HasBeenSeen = false
	MiddleScreenText = VERIDIAN CITY, GYM SIGN
	HoverText = Did you hear about his secret experiment...?
	SelectText = "Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"

  	[RUNNER]
	SpriteLocation = Graphics/Characters/boy_run.png
	HasBeenSeen = true
	IsAnimated = true # IsAnimated is all that I need for this one, as it is a standard 16 frame file
	MiddleScreenText = CITY, GYM SIGN
	HoverText = Did you hear about his secret experiment...?
	SelectText = "Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"

  	[RUNNER2] # must be unique
	SpriteLocation = Graphics/Characters/boy_run.png
	HasBeenSeen = true
	Frames = 16 # IsAnimated will handle all of this without needing to be input
    	FrameSize = 32, 48 # however this is still possible
    	FrameSkip = 4
    	FramesToShow = 0, 3
	MiddleScreenText = CITY, GYM SIGN
	HoverText = Did you hear about his secret experiment...?
	SelectText = "Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"
}
#--------------------------------------------
[DAISY]
Name = Daisy
SpriteLocation = Graphics/Pictures/FameChecker/DeviceSprites/DAISY.png
HasBeenSeen = true
FameInfo = {
	[EXPERIMENT]
	SpriteLocation = Graphics/Pictures/FameChecker/SmallSprites/GymSign.png
	HasBeenSeen = True
	Frames = 1
	FramesToShow = 0, 0
	FrameSkip = 0
	FrameSize = 64, 64
	MiddleScreenText = VERIDIAN CITY, GYM SIGN
	HoverText = Did you hear about his secret experiment...?
	SelectText = "Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"
}
```

#### If There are any questions or bug reports, please don't hesitate to shoot me a message on [Relic Castle](https://reliccastle.com/members/13920/) or report a bug on the issues tab
