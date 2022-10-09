module FameChecker
  # This is the function that you want to run in any situation other than using the Fame Checker item
  def self.startFameChecker()
    pbFadeOutIn {
      @@compiledData = load_data("Data/fame_targets.dat") rescue {} if @@compiledThisLaunch and !@@reloaded
      @@reloaded = true
      puts($PokemonGlobal.FamousPeople)
      FameChecker.createSaveHash()
      FameChecker.convertOldSave()
      runtimeHandler = RuntimeHandler.new
      runtimeHandler.run()
      FameChecker.cleanup()
    }
  end

  # Use this function to set whether a famous person has been seen.
  # Generally, you want to use this function when the player first hears about a person or talks to that person.
  def self.setFameSeen(famousPerson, seen = true)
    return if not $PokemonGlobal.FamousPeople[famousPerson]
    $PokemonGlobal.FamousPeople[famousPerson][:HasBeenSeen] = seen
  end

  def self.setFameInfoSeen(famousPerson, info, seen = true)
    return if not $PokemonGlobal.FamousPeople[famousPerson]
    if info.is_a?(Integer)
      if info < $PokemonGlobal.FamousPeople[famousPerson][:FameInfo].length and $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][info] != seen
        $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][info] = seen
        $PokemonGlobal.FamousPeople[famousPerson][:Complete][0] += seen == true ? 1 : -1
      end
    elsif info.is_a?(Symbol)
      val = @@compiledData[famousPerson][:FameLookup][info]
      if val and $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][val] != seen
        $PokemonGlobal.FamousPeople[famousPerson][:FameInfo][val] = seen
        $PokemonGlobal.FamousPeople[famousPerson][:Complete][0] += seen == true ? 1 : -1
      end
    end
  end
end
