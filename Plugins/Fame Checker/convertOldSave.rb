module FameChecker
  # the conversion process will delete all excess values after converting what it can find from the new data
  # please ensure that you have everything that you want to include when this function is called.
  # if you don't want it to run until you are done adding everything make sure to include within the
  # config.txt file the rule dontConvertOldSave = true
  # doing so will prevent this function from running, you can remove it later after you have transfered everything over.
  def self.convertOldSave()
    return if not $PokemonGlobal.FameTargets
    puts("Old Save File detected, beginning conversion...")
    oldFame = $PokemonGlobal.FameTargets
    oldInfo = $PokemonGlobal.FameInfo
    $PokemonGlobal.FamousPeople.each { |key, val|
      oldName = ""
      if val[:OldName] and oldFame[val[:OldName]]
        oldName = val[:OldName]
      elsif oldFame[key.to_s]
        oldName = key.to_s
      end
      next if oldName == ""
      val[:HasBeenSeen] = oldFame[oldName]["seen"] if oldFame[oldName]["seen"] == true
      oldFame.delete(oldName)

      if oldInfo[oldName]
        smaller = oldInfo[oldName].length < val[:FameInfo].length ? oldInfo[oldName].length : val[:FameInfo].length
        for i in 0...smaller
          val[:Complete][0] += 1 if val[:FameInfo][i] == false and oldInfo[oldName][i]["seen"] == true
          val[:FameInfo][i] = oldInfo[oldName][i]["seen"] if oldInfo[oldName][i]["seen"] == true
        end
      end
    }
    puts("Conversion Completed,", "The following is a list of famous people that were not found:")
    remaining = ""
    $PokemonGlobal.FameTargets.each { |key, val|
      remaining += "#{key}, "
    }
    puts(remaining, "All old save file data will now be wiped from the save file,",
          "You can return to before the save conversion by closing the program without saving.")
    $PokemonGlobal.FameTargets = nil
    $PokemonGlobal.FameInfo = nil
  end
end
