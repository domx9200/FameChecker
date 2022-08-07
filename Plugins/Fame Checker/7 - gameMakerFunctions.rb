module FameChecker

  # please make sure that when you call this function, you use the name of the person you
    # previously used when first inputting the character.
  # famousPersonName = string, is used to look up a specific person, example "BROCK"
    # note that "BROCK" would be the original name given, "Brock", or "brock" wouldn't work
  # hasMet = boolean, not required, defaults to true, assuming you mainly want to set that the
    # player has encountered a specific person, is often times called when first meeting them in person
    # however isn't limited to those uses.
  # this function is usually to be called during a scripting event with that person, 
	# but isn't supposed to be displayed
  def self.hasEncountered(famousPersonName, hasMet = true)
    FameChecker.checkSetup
    FameChecker.runSetup

    if !$PokemonGlobal.FameTargets[famousPersonName]
      print("name input doesn't exist")
      return
    end
    $PokemonGlobal.FameTargets[famousPersonName]["seen"] = hasMet
  end

  # please make sure that when you call this function, you use the name of the person you
    # previously used when first inputting the character.
  # famousPersonName = string, is used to look up a specific person, example "BROCK"
    # note that "BROCK" would be the original name given, "Brock", or "brock" wouldn't work
  # InfoNum = integer, can be any number, however doesn't do anything if it cannot find
    # the info target you want to set as found. 
    # note, the starting number is 0 not 1.
  # hasFound = boolean, not required, defaults to true, assuming you mainly want to set that the
    # player has encountered an NPC that has given them some info about the specific character.
  # this is usually called during the text boxes that relay that info, and is usually not to be displayed.
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

  # for debugging purposes, usually you want to call it, store the value in the npc script
    # and then print it within that script. You can probably use it for a fame checker NPC if you want one.
  def self.printFoundStatus(famousPersonName)
    FameChecker.checkSetup
    FameChecker.runSetup

    if !$PokemonGlobal.FameTargets[famousPersonName]
      print("name input doesn't exist")
      return
    end
    return $PokemonGlobal.FameTargets[famousPersonName]["seen"]
  end

  # note, this is ONLY to be called upon the initialization of a new save file, or when you want to introduce
    # a new character that was not previously within the game, such as in the case of an update from a previous version
  # personName = string, represents the name of a specific person, all names must be different, example "BROCK"
  # fileName = string, represents the image that will be displayed on screen for a specific person,
    # example "BROCK.png", note that you should have the file within the big_sprites folder
  # hasMet = boolean, not required, can be true or false, defaults to false when not given
    # decides if the player has met the person in question, normally the player wouldn't have at the beginning
    # of the game, so false is the default statement.
  # If you want to use this function within the game's interface, it must be called using FameChecker.createFamousPerson
  def self.createFamousPerson(personName, fileName, hasMet = false)
    FameChecker.checkSetup
    newHash = {}
    newHash["fileName"] = fileName.upcase
    newHash["seen"] = hasMet
    $PokemonGlobal.FameTargets[personName] = newHash
  end

  # personName = string, represents the name of a specific person, all names must be different, example "BROCK"
  # fileName = string, represents the image that will be displayed on screen for a specific person,
    # example "old_lady.png", note that you should have the file within the Small_sprites folder
  # textBoxText = array of strings, must be of size 2, represents the value that appears within the blue frame, example ["VERIDIAN CITY", "GYM SIGN"]
  # selectText = array of strings, represents the text that is displayed when you select that specific info person, 
    # example ["Oak is an interesting man, he apparently created MISSINGNO!","I get it, you're skeptical, but it's true, he really did!"]
    # note, this can be any size, just make sure to seperate sentances in this way.
  # hoverText = string, represents the text that is supposed to display when the player is hovering over that specific info person,
    # example, "Did you hear about his secret experiment..."
  # hasMet = boolean, not required, can be true or false, defaults to false when not given
    # decides if the player has seen the info in question, normally the player wouldn't have at the beginning
    # of the game, so false is the default statement.
  # If you want to use this function within the game's interface, it must be called using FameChecker.createFameInfo
  def self.createFameInfo(personName, fileName, textBoxText, selectText, hoverText, hasMet = false)
    FameChecker.checkSetup
    if !$PokemonGlobal.FameTargets[personName]
      print("name input doesn't exist")
      return
    end
    if !$PokemonGlobal.FameInfo[personName]
      $PokemonGlobal.FameInfo[personName] = {}
    end
    temp = $PokemonGlobal.FameInfo[personName]
    newHash = {}
    newHash["fileName"] = fileName
    newHash["infoText"] = textBoxText
    newHash["selectText"] = selectText
    newHash["hoverText"] = hoverText
    newHash["seen"] = hasMet
    temp[temp.size] = newHash
  end

  # this function is where you place every call of createFamousPerson
  # within the function is a template for you to copy to your hearts content
  # please ensure that the files are within Graphics/Pictures/FameChecker/Big_Sprites else it will throw an error
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

  # this function is where you place every call of createFameInfo
  # within the function is a template for you to copy to your hearts content
  # please ensure that the files are within Graphics/Pictures/FameChecker/small_sprites and that the name you use is correct for each
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
end