module FameChecker
  FAME_SWITCH = 2765 # default switch value, just change this value to anything 5000 or less if switch 2765 is already in use
  COMPILE_FOLDER = "PBS/FameChecker" # default folder location of the PBS file is PBS/FameChecker, If you want it to compile from another location, just change this

  # This is the function that you want to run in any situation other than using the Fame Checker item
  def self.startFameChecker()
    pbFadeOutIn {
      self.ensureCompiledData()
      runtimeHandler = RuntimeHandler.new
      runtimeHandler.run()
      self.cleanup()
    }
  end

  # Use this function to set whether a famous person has been seen.
  # Generally, you want to use this function when the player first hears about a person or talks to that person.
  # famousPerson => Symbol or String, if it is a string, then it gets converted to a symbol
  # FameChecker.setFameSeen("OAK", true) translates to FameChecker.setFameSeen(:OAK, true)
  def self.setFameSeen(famousPerson, seen = true)
    self.ensureCompiledData()
    famousPerson = famousPerson.to_sym if famousPerson.is_a?(String)
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return
    end
    $PokemonGlobal.FamousPeople[famousPerson][:HasBeenSeen] = seen
    $game_switches[FAME_SWITCH] = self.completed?()
  end

  # Use this function to set whether an info piece of a famous person has been seen
  # famousPerson => Symbol or String, if it is a string, then it gets converted to a symbol
  # info => Integer, (Symbol or String), if it is a string, then it gets converted to a symbol
  #   If it is a String or Symbol, it will get the position from a lookup table
  #   If it is an integer, it will just use that location
  # FameChecker.setFameInfoSeen("OAK", "EXPERIMENT", true) translates to FameChecker.setFameInfoSeen(:OAK, :EXPERIMENT, true)
  def self.setFameInfoSeen(famousPerson, info, seen = true)
    self.ensureCompiledData()
    famousPerson = famousPerson.to_sym if famousPerson.is_a?(String)
    info = info.to_sym if info.is_a?(String)
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return
    end
    if info.is_a?(Integer)
      if info < $PokemonGlobal.FamousPeople[famousPerson][:FameInfo].length and $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][info] != seen
        $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][info] = seen
        $PokemonGlobal.FamousPeople[famousPerson][:Complete][0] += seen == true ? 1 : -1
      elsif info >= $PokemonGlobal.FamousPeople[famousPerson][:FameInfo].length
        puts("#{info} is larger than the length of #{famousPerson}'s InfoList")
        return
      else
        return
      end
    elsif info.is_a?(Symbol)
      val = @@compiledData[famousPerson][:FameLookup][info]
      if val and $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][val] != seen
        $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][val] = seen
        $PokemonGlobal.FamousPeople[famousPerson][:Complete][0] += seen == true ? 1 : -1
      elsif not val
        puts("info symbol #{info} was not found within #{famousPerson}'s lookup table")
        return
      else
        return
      end
    else
      puts("info was neither an Integer, or a Symbol")
      return
    end
    $game_switches[FAME_SWITCH] = self.completed?()
  end

  # Use this function to see if a famous person has been seen
  # famousPerson => Symbol or String, if it is a string, then it gets converted to a symbol
  # FameChecker.fameStatus?("OAK") translates to FameChecker.fameStatus?(:OAK)
  def self.fameStatus?(famousPerson)
    self.ensureCompiledData()
    famousPerson = famousPerson.to_sym if famousPerson.is_a?(String)
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return false
    end
    return $PokemonGlobal.FamousPeople[famousPerson][:HasBeenSeen]
  end

  # Use this function to see if a specific piece of info on a famous person has been seen.
  # famousPerson => Symbol or String, if it is a string, then it gets converted to a symbol
  # info => Integer, (Symbol or String), if it is a string, then it gets converted to a symbol
  #   If it is a String or Symbol, it will get the position from a lookup table
  #   If it is an integer, it will just use that location
  # FameChecker.infoStatus?("OAK", "EXPERIMENT") translates to FameChecker.infoStatus?(:OAK, :EXPERIMENT)
  def self.infoStatus?(famousPerson, info)
    self.ensureCompiledData()
    famousPerson = famousPerson.to_sym if famousPerson.is_a?(String)
    info = info.to_sym if info.is_a?(String)
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return false
    end
    if info.is_a?(Integer)
      if info < $PokemonGlobal.FamousPeople[famousPerson][:FameInfo].length
        return $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][info]
      end
      puts("#{info} is larger than the length of #{famousPerson}'s InfoList")
      return false
    elsif info.is_a?(Symbol)
      val = @@compiledData[famousPerson][:FameLookup][info]
      if val
        return $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][val]
      end
      puts("info symbol #{info} was not found within #{famousPerson}'s lookup table")
      return false
    end
    puts("info was neither an Integer, or a Symbol")
    return false
  end

  # Use this function to change the name of a famous person from it's default
  # famousPerson => Symbol or String, if it is a string, then it gets converted to a symbol
  # newName => String
  # FameChecker.changeFameName("OAK", "ROWAN") translates to FameChecker.changeFameName(:OAK, "ROWAN")
  # IMPORTANT NOTE:
  #   If you use this function it will mean that the new name will be saved to the save file,
  #   If you change the name of the character within the PBS file afterwards it will not reflect on the famous people
  #   that have used this function. That being said, the main usage of this function is to change the name of a famous person
  #   through story beats. So it would be unlikely that you would have to change it.
  def self.changeFameName(famousPerson, newName)
    self.ensureCompiledData()
    famousPerson = famousPerson.to_sym if famousPerson.is_a?(String)
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return
    end
    $PokemonGlobal.FamousPeople[famousPerson][:Name] = newName
  end

  # Use this function to get the current display name of a famous person
  # famousPerson => Symbol or String, if it is a string, then it gets converted to a symbol
  # FameChecker.getFameName("OAK") translates to FameChecker.fetFameName(:OAK)
  def self.getFameName(famousPerson)
    self.ensureCompiledData()
    famousPerson = famousPerson.to_sym if famousPerson.is_a?(String)
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return
    end
    return $PokemonGlobal.FamousPeople[famousPerson][:Name] ? $PokemonGlobal.FamousPeople[famousPerson][:Name] : @@compiledData[famousPerson][:Name]
  end

  # Use this function to remove the current display name, provided it was changed in the first place
  # famousPerson => Symbol or String, if it is a string, then it gets converted to a symbol
  # FameChecker.removeFameName("OAK") translates to FameChecker.removeFameName(:OAK)
  def self.removeFameName(famousPerson)
    self.ensureCompiledData()
    famousPerson = famousPerson.to_sym if famousPerson.is_a?(String)
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return
    end
    $PokemonGlobal.FamousPeople[famousPerson].delete(:Name) if $PokemonGlobal.FamousPeople[famousPerson][:Name]
  end
end
