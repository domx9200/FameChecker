module FameChecker
  class FC
    def checkInput(input)
      return true if Input.trigger?(input)
      return false
    end

    # to be deprecated
    def inputFamousPerson(name = nil, hash = nil)
      return if name == nil || hash == nil
      hash["seen"] = false
      $PokemonGlobal.FameTargets[name] = hash;
    end

    # has should be in the format of
    # {"fileName" = "filename", "infoText" = ["text 1", "text 2"]}
    # seen will be tacked on in the function
    def inputFamePersonInfo(position = nil, name = nil, hash = nil)
      return if position == nil || name == nil || hash == nil || !$PokemonGlobal.FameTargets[name]
      hash["seen"] = false
      fameInfo = $PokemonGlobal.FameInfo
      fameInfo[name] = {} if !fameInfo[name]
      fameInfo[name][position] = hash
      $PokemonGlobal.FameInfo = fameInfo
    end

    def listInput(list = true)
      if list 
        if self.checkInput(Input::USE) # starts info select
          if @namePosList[@currentPos] == "CANCEL" # ends program if cancel
            self.playSE(1)
            return 0
          end
          self.playSE(0)
          return 2
        elsif self.checkInput(Input::ACTION) # start big sprite
          self.playSE(0) if @namePosList[@currentPos] != "CANCEL"
          return @namePosList[@currentPos] != "CANCEL" ? 3 : 6
        end
      end
      if self.checkInput(Input::BACK) # end program
        self.playSE(1) if list
        return 0
      elsif self.checkInput(Input::UP)
        self.playSE(0) if self.positionListArrow(true)
        return 4
      elsif self.checkInput(Input::DOWN)
        self.playSE(0) if self.positionListArrow(false)
        return 5
      elsif self.checkInput(Input::USE) && @namePosList[@currentPos] == "CANCEL"
        self.playSE(1)
        return 0
      end
      return 6
    end

    def infoinput(currentFame, currentPage)
      if self.checkInput(Input::USE)
        if !$PokemonGlobal.FameInfo[currentFame][@currentInfoPos + 6 * (currentPage - 1)]["seen"]
          return 7
        end
        return 1
      elsif self.checkInput(Input::BACK)
        return 2
      elsif self.checkInput(Input::LEFT)
        return 3
      elsif self.checkInput(Input::UP)
        return 4
      elsif self.checkInput(Input::RIGHT)
        return 5
      elsif self.checkInput(Input::DOWN)
        return 6
      end
      return 7
    end
  end
end