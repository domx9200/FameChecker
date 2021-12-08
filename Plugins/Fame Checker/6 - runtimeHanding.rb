module FameChecker
  class FC
    def end()
      self.dispose
      @vp.dispose
    end

    # just defines total for animation, as well as manages transitions from location to location
    # it won't be doing anything like checking input, that will be left to the individual run functions
    # 0 = end program, 1 = select list , 2 = info select, 3 = device
    def run()
      choice = 1
      @sprites["upListArrow"].play
      @sprites["downListArrow"].play
      @sprites["leftListArrow"].play
      @sprites["rightListArrow"].play
      @sprites["selectBox"].play
      Input.update
      loop do
        if choice == 1
          choice = self.listRun
        elsif choice == 2
          choice = self.infoRun
        elsif choice == 3
          choice = self.deviceRun
        else
          break
        end
      end
    end

    def listRun()
      self.setButtons(["cancel.png", "checkInfo.png", "listSelect.png", "bigSprite.png"])
      currFame = @namePosList[@currentPos]
      self.displayInfoSprites(currFame)
      input = -1
      atTopEdge = self.atListEdge == 1 ? true : false
      atBotEdge = self.atListEdge == 2 ? true : false
      loop do
        msgBox = pbCreateMessageWindow(nil, nil)
        messageOutput = self.messageDisplay(msgBox, currFame != "CANCEL" ? "" : "The Fame Checker will be closed", true, false, false){
          pbUpdateSpriteHash(@sprites)
          input = self.listInput
          if input == 4 && !atTopEdge
            break
          elsif input == 5 && !atBotEdge
            break
          elsif input < 4
            break
          end
        }
        pbDisposeMessageWindow(msgBox)
        if messageOutput == 0
          input = 0
        end
        if input < 4
          return input
        elsif input >= 4
          currFame = @namePosList[@currentPos]
          temp = self.displayInfoSprites(currFame)
          self.disposeAll() if temp == 0
          if self.atListEdge == 1
            atTopEdge = true
            atBotEdge = false
          elsif self.atListEdge == 2
            atTopEdge = false
            atBotEdge = true
          else
            atTopEdge = false
            atBotEdge = false
          end
        end
      end
    end

    def deviceRun()
      self.setButtons(["cancel.png","listSelect.png"])
      deviceMoving = true
      deviceReverse = false
      deviceMoveSize = @sprites["device"].bitmap.width / 35

      currFame = @namePosList[@currentPos]
      if currFame != "CANCEL"
        self.changeBitmap("bigSprite", "Big_Sprites",  $PokemonGlobal.FameTargets[currFame]["fileName"]) 
      else
        self.clearBitmap("bigSprite")
      end
      input = -1
      messageOutput = -1
      atTopEdge = self.atListEdge == 1 ? true : false
      atBotEdge = self.atListEdge == 2 ? true : false

      loop do
        if !deviceMoving
          if input == 1
            @sprites["spinBall"].angle = 0
            return 1
          end
          msgBox = pbCreateMessageWindow(nil, nil)
          messageOutput = self.messageDisplay(msgBox, currFame != "CANCEL" ? currFame.upcase : "The Fame Checker will be closed", true, false, false){
            pbUpdateSpriteHash(@sprites)
            @sprites["spinBall"].angle += 5
            # input process second
            input = self.listInput(false)
            if input == 4 && !atTopEdge
              break
            elsif input == 5 && !atBotEdge
              break
            elsif input < 4
              break
            end
          } 
          pbDisposeMessageWindow(msgBox)
          if messageOutput == 0
            input = messageOutput
          end

          if input != 4 && input != 5 && input != 0
            input = -1
          elsif input == 0
            if currFame == "CANCEL" && !Input.trigger?(Input::BACK)
              self.playSE(1)
              return 0 
            end
            deviceMoving = true
            deviceReverse = true
            input = 1
            Input.update
          elsif input >= 4
            input = -1
            currFame = @namePosList[@currentPos]
            if self.atListEdge == 1
              atTopEdge = true
              atBotEdge = false
            elsif self.atListEdge == 2
              atTopEdge = false
              atBotEdge = true
            else
              atTopEdge = false
              atBotEdge = false
            end
            if currFame != "CANCEL"
              self.changeBitmap("bigSprite", "Big_Sprites",  $PokemonGlobal.FameTargets[currFame]["fileName"]) 
            else
              self.clearBitmap("bigSprite")
            end
            Input.update
          end
        else
          msgBox = pbCreateMessageWindow(nil, nil)
          messageOutput = self.messageDisplay(msgBox, "", true, false, false){
            pbUpdateSpriteHash(@sprites)
            @sprites["spinBall"].angle += 5
            if !deviceReverse
              self.moveDeviceSprites("device", ["spinBall", "bigSprite"], @sprites["device"].x - deviceMoveSize)
              if @sprites["device"].x < @deviceXEnd
                self.moveDeviceSprites("device", ["spinBall", "bigSprite"], @deviceXEnd)
                deviceMoving = false
                break
              end
            else
              self.moveDeviceSprites("device", ["spinBall", "bigSprite"], @sprites["device"].x + deviceMoveSize)
              if @sprites["device"].x > Graphics.width
                self.moveDeviceSprites("device", ["spinBall", "bigSprite"], Graphics.width)
                deviceMoving = false
                break
              end
            end
          }
          pbDisposeMessageWindow(msgBox)
        end
      end
    end

    # @currentInfoPos = 0 at start
    def infoRun()
      self.setButtons(["cancel.png", "readInfo.png", "infoSelect.png"])
      currFame = @namePosList[@currentPos]
      infoList = $PokemonGlobal.FameInfo[currFame]
      return 1 if !infoList
      currPage = 1
      maxPage = 0
      infoTotal = infoList.length
      
      currentFrame = 0
      pauseFrames = 3

      topVis = @sprites["upListArrow"].visible
      botVis = @sprites["downListArrow"].visible
      @sprites["upListArrow"].visible = false
      @sprites["downListArrow"].visible = false

      if infoTotal > 6
        @sprites["rightListArrow"].visible = true
      end

      loop do
        maxPage += 1
        infoTotal -= 6
        if infoTotal < 1
          break
        end
      end

      self.swapListArrowTexture

      currShowTotal = displayInfoSprites(currFame, currPage)
      if currShowTotal != 0
        @sprites["selectBox"].visible = true
        self.setSelectBoxPos(0)
        if infoList[@currentInfoPos]["seen"]
          self.makeInfoGreyScale(@currentInfoPos)
          self.setInfoBoxText(infoList[@currentInfoPos]["infoText"])
        end
      end
      backGround = 0
      input = 7

      loop do
        msgBox = pbCreateMessageWindow(nil, nil)
        self.messageDisplay(msgBox, infoList[@currentInfoPos + 6 * (currPage - 1)]["seen"] ? infoList[@currentInfoPos + 6 * (currPage - 1)]["hoverText"] : "", true, false, false){
          pbUpdateSpriteHash(@sprites)
          if currentFrame % pauseFrames == 0
            if infoList[@currentInfoPos + 6 * (currPage - 1)]["seen"] && backGround != 2
              backGround += 1
              self.setBackground(backGround)
            elsif !infoList[@currentInfoPos + 6 * (currPage - 1)]["seen"] && backGround != 0
              backGround -= 1
              self.setBackground(backGround)
            end
          end
          currentFrame += 1
          input = self.infoinput(currFame, currPage)
          break if input != 7
        }
        pbDisposeMessageWindow(msgBox)

        if input == 1 # input for pressing USE
          msgBox = pbCreateMessageWindow(nil, nil)
          infoList[@currentInfoPos + 6 * (currPage - 1)]["selectText"].each {|text|
            puts("in USE loop")
            self.messageDisplay(msgBox, text){
              pbUpdateSpriteHash(@sprites)
            }
          } # errors currently as there is no data to grab
          pbDisposeMessageWindow(msgBox)
        elsif input == 2 # input for pressing BACK
          @sprites["leftListArrow"].visible = false
          @sprites["rightListArrow"].visible = false
          @sprites["selectBox"].visible = false
          msgBox = pbCreateMessageWindow(nil, nil)
          self.messageDisplay(msgBox, "", true, false, false){
            if backGround != 0
              backGround -= 1
            end
            self.setBackground(backGround)
            pbUpdateSpriteHash(@sprites)
            if backGround == 0
              break
            end
          }
          pbDisposeMessageWindow(msgBox)
          @sprites["upListArrow"].visible = topVis
          @sprites["downListArrow"].visible = botVis
          @currentInfoPos = 0
          self.swapListArrowTexture
          return 1
        elsif input == 3 # input for LEFT
          changeSelection = false
          changeSelection = true if @currentInfoPos != 0
          if @currentInfoPos == 0 && currPage > 1
            currPage -= 1
            currShowTotal = displayInfoSprites(currFame, currPage)
            @currentInfoPos = currShowTotal == 4 ? 1 : currShowTotal > 4 ? 2 : currShowTotal - 1
          end
          if currShowTotal == 4 && @currentInfoPos == 2
            changeSelection = false
            if currPage > 1
              currPage -= 1
              currShowTotal = displayInfoSprites(currFame, currPage)
              @currentInfoPos = currShowTotal == 4 ? 1 : currShowTotal > 4 ? 2 : currShowTotal - 1
            end
          elsif currShowTotal > 4 && @currentInfoPos == 3
            changeSelection = false
            if currPage > 1
              currPage -= 1
              currShowTotal = displayInfoSprites(currFame, currPage)
              @currentInfoPos = currShowTotal == 4 ? 1 : currShowTotal > 4 ? 2 : currShowTotal - 1
            end
          end
          if changeSelection
            @currentInfoPos -= 1
          end
          if currPage == 1
            @sprites["leftListArrow"].visible = false
          end
          if currPage < maxPage
            @sprites["rightListArrow"].visible = true
          end
        elsif input == 4 # input for UP
          if currShowTotal == 4 && @currentInfoPos > 1
            @currentInfoPos -= 2
          elsif currShowTotal > 4 && @currentInfoPos > 2
            @currentInfoPos -= 3
          end
        elsif input == 5 # input for RIGHT
          changeSelection = false
          changeSelection = true if @currentInfoPos != currShowTotal - 1
          if @currentInfoPos == currShowTotal - 1 && currPage < maxPage
            currPage += 1
            currShowTotal = displayInfoSprites(currFame, currPage)
          end
          if currShowTotal == 4 && @currentInfoPos == 1
            changeSelection = false
            if currPage < maxPage
              currPage += 1
              currShowTotal = displayInfoSprites(currFame, currPage)
            end
          elsif currShowTotal > 4 && @currentInfoPos == 2
            changeSelection = false
            if currPage < maxPage
              currPage += 1
              currShowTotal = displayInfoSprites(currFame, currPage)
            end
          end
          if changeSelection
            @currentInfoPos += 1
          end
          if currPage == maxPage
            @sprites["rightListArrow"].visible = false
          end
          if currPage > 1
            @sprites["leftListArrow"].visible = true
          end
        elsif input == 6 # input for DOWN
          if currShowTotal == 4 && @currentInfoPos < 2
            @currentInfoPos += 2
          elsif currShowTotal == 5
            if @currentInfoPos < 2
              @currentInfoPos = 3
            elsif @currentInfoPos == 2
              @currentInfoPos = 4
            end
          elsif currShowTotal == 6 && @currentInfoPos < 3
            @currentInfoPos += 3
          end
        end
        self.setSelectBoxPos(@currentInfoPos)
        if infoList[@currentInfoPos + 6 * (currPage - 1)]["seen"]
          self.setInfoBoxText(infoList[@currentInfoPos + 6 * (currPage - 1)]["infoText"]) 
          self.makeInfoClean()
          self.makeInfoGreyScale(@currentInfoPos)
        else
          self.makeInfoClean()
        end
      end
    end
  end
end