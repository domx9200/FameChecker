module FameChecker
  FAME_SWITCH = 2765 # default switch value, just change this value to anything 5000 or less if switch 2765 is already in use

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
  def self.setFameSeen(famousPerson, seen = true)
    self.ensureCompiledData()
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return
    end
    $PokemonGlobal.FamousPeople[famousPerson][:HasBeenSeen] = seen
    $game_switches[FAME_SWITCH] = self.completed?()
  end

  # Use this function to set whether an info piece of a famous person has been seen
  # info can be either an Integer, representing a position,
  # or a Symbol, representing the name givin in the pbs file. example => :EXPERIMENT
  def self.setFameInfoSeen(famousPerson, info, seen = true)
    self.ensureCompiledData()
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
  def self.fameStatus?(famousPerson)
    self.ensureCompiledData()
    if not $PokemonGlobal.FamousPeople[famousPerson]
      puts("#{famousPerson} doesn't exist")
      return false
    end
    return $PokemonGlobal.FamousPeople[famousPerson][:HasBeenSeen]
  end

  # Use this function to see if a specific piece of info on a famous person has been seen.
  # info can be either an Integer, representing a position,
  # or a Symbol, representing the name givin in the pbs file. example => :EXPERIMENT
  def self.infoStatus?(famousPerson, info)
    self.ensureCompiledData()
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
end
