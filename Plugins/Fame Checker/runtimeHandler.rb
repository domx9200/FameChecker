module FameChecker
  class RuntimeHandler
    include FameChecker
    # defines the base elements, including the other needed objects for runtime
    def initialize()
      @@vp = Viewport.new(0,0,Graphics.width,Graphics.height)
      @@vp.z = 99999
      @@sprites = {}


      @background = Background.new(0)
      @fameList = FameList.new()
      @device = Device.new()
      @infoList = InfoList.new()
    end

    def run()
      mode = :FameList
      loop do
        case mode
        when :FameList
          mode = self.runFameList()
        when :InfoList
          # break
          @fameList.swapListArrowTexture()
          self.runInfoList()
          mode = :FameList
          @fameList.swapListArrowTexture()
        when :Close
          break
        end
        pbUpdateSpriteHash(@@sprites)
      end
    end

    # Fame List and Device run time
    def runFameList()
      @background.setButtons([:cancelButton, :checkInfoButton, :listSelectButton, :bigSpriteButton])
      currentFame = @fameList.getCurrentPosition()
      @device.setDeviceSprite(currentFame)
      @infoList.setFamousPerson(currentFame, true)
      input = -1
      ballRotation = 0
      pbUpdateSpriteHash(@@sprites)
      loop do
        msgBox = pbCreateMessageWindow()
        message = ""
        if @device.deviceIn
          message = "CANCEL"
          if currentFame != :CANCEL
            name = $PokemonGlobal.FamousPeople[currentFame][:Name]
            name = @@compiledData[currentFame][:Name] if !name
            check = $PokemonGlobal.FamousPeople[currentFame][:Complete]
            message = "From: #{name.upcase}\nTo: #{$Trainer.name}" if check[0] == check[1]
            message = name.upcase if (check[0] != check[1] or COMPLETION_TEXT == false)
          end
        else
          message = currentFame != :CANCEL ? "" : "The Fame Checker will be closed"
        end
        messageOutput = self.messageDisplay(msgBox, message, true, nil, false, true){
          @@sprites[:deviceBall].angle += ballRotation
          pbUpdateSpriteHash(@@sprites)
          if Input.trigger?(Input::UP)
            input = Input::UP
            break
          elsif Input.trigger?(Input::DOWN)
            input = Input::DOWN
            break
          elsif Input.trigger?(Input::ACTION)
            input = Input::ACTION
            break if !@device.deviceIn
          elsif Input.trigger?(Input::USE)
            input = Input::USE
            break if @fameList.getCurrentPosition == :CANCEL
            check = $PokemonGlobal.FamousPeople[currentFame][:Complete]
            break if !@device.deviceIn and !@infoList.noElems or (@device.deviceIn and check[0] == check[1])
          end
        }
        pbDisposeMessageWindow(msgBox)
        input = messageOutput if messageOutput == Input::USE or messageOutput == Input::BACK

        case input
        when Input::UP
          ret = @fameList.shiftListUp()
          if ret != -1
            currentFame = ret
            pbPlayDecisionSE
            @device.setDeviceSprite(currentFame)
            @infoList.setFamousPerson(currentFame, true)
          end
        when Input::DOWN
          ret = @fameList.shiftListDown()
          if ret != -1
            currentFame = ret
            pbPlayDecisionSE
            @device.setDeviceSprite(currentFame)
            @infoList.setFamousPerson(currentFame, true)
          end
        when Input::USE
          if @fameList.getCurrentPosition == :CANCEL
            pbPlayCloseMenuSE
            return :Close
          end
          check = $PokemonGlobal.FamousPeople[currentFame][:Complete]
          if @device.deviceIn and check[0] == check[1]
            msgBox = pbCreateMessageWindow()
            @@compiledData[currentFame][:PlayerMessage].each { |line|
              self.messageDisplay(msgBox, line){
                @@sprites[:deviceBall].angle += ballRotation
                pbUpdateSpriteHash(@@sprites)
              }
            }
            pbDisposeMessageWindow(msgBox)
          else
            pbPlayDecisionSE
            return :InfoList
          end
        when Input::ACTION
          if !@device.deviceIn
            pbPlayDecisionSE
            @background.setButtons([:cancelButton, :listSelectButton])
            msgBox = pbCreateMessageWindow()
            self.messageDisplay(msgBox, ""){
              @device.moveDeviceIn()
              break
            }
            pbDisposeMessageWindow(msgBox)
            ballRotation = 5
          end
        when Input::BACK
          if @device.deviceIn
            @background.setButtons([:cancelButton, :checkInfoButton, :listSelectButton, :bigSpriteButton])
            msgBox = pbCreateMessageWindow()
            self.messageDisplay(msgBox, ""){
              @device.moveDeviceOut()
              break
            }
            pbDisposeMessageWindow(msgBox)
            ballRotation = 0
          else
            pbPlayCloseMenuSE
            return :Close
          end
        end
      end
    end

    def runInfoList()
      @background.setButtons([:cancelButton, :readInfoButton, :infoSelectButton])
      @infoList.setFamousPerson(@infoList.currentInfoPerson)
      @@sprites[:SelectBox].visible = true
      @infoList.updateArrowVisibility()

      background = 0
      infoElems = @@compiledData[@infoList.currentInfoPerson][:FameInfo]
      cutoff = @infoList.elementCount() > 3 ? (@infoList.elementCount() / 2.0).ceil - 1 : -1
      changePage = false
      input = -1

      msgBox = pbCreateMessageWindow()
      self.messageDisplay(msgBox, "", true, nil, false, false){
        background += 1
        @background.setBackground(background)
        pbUpdateSpriteHash(@@sprites)
        break if background == 2
      }
      pbDisposeMessageWindow(msgBox)

      loop do
        msgBox = pbCreateMessageWindow()
        seen = $PokemonGlobal.FamousPeople[@infoList.currentInfoPerson][:FameInfo][@infoList.currentElement]
        message = (infoElems[@infoList.currentElement][:HoverText] and seen) ? infoElems[@infoList.currentElement][:HoverText] : ""
        messageOutput = self.messageDisplay(msgBox, message, true, nil, false, false){
          pbUpdateSpriteHash(@@sprites)
          if Input.trigger?(Input::LEFT)
            input = Input::LEFT
            pos = @infoList.currentPosition
            if pos != 0 and pos != (cutoff + 1)
              changePage = false
              break
            elsif @infoList.currentPage > 1
              changePage = true
              break
            end
          elsif Input.trigger?(Input::RIGHT)
            input = Input::RIGHT
            pos = @infoList.currentPosition
            if pos != @infoList.elementCount() - 1 and pos != cutoff
              changePage = false
              break
            elsif @infoList.currentPage < @infoList.maxPages
              changePage = true
              break
            end
          elsif Input.trigger?(Input::UP)
            input = Input::UP
            break if @infoList.elementCount > 3 and @infoList.currentPosition > cutoff
          elsif Input.trigger?(Input::DOWN)
            input = Input::DOWN
            break if @infoList.elementCount > 3 and @infoList.currentPosition <= cutoff
          elsif Input.trigger?(Input::USE)
            input = Input::USE
            break
          elsif Input.trigger?(Input::BACK)
            input = Input::BACK
            break
          end
        }
        pbDisposeMessageWindow(msgBox)

        case input
        when Input::LEFT
          pbPlayDecisionSE
          if changePage
            @infoList.changePageLeft()
            cutoff = @infoList.elementCount() > 3 ? (@infoList.elementCount() / 2.0).ceil - 1 : -1
          else
            @infoList.changePosition(@infoList.currentPosition - 1)
          end
        when Input::RIGHT
          pbPlayDecisionSE
          if changePage
            @infoList.changePageRight()
            cutoff = @infoList.elementCount() > 3 ? (@infoList.elementCount() / 2.0).ceil - 1 : -1
          else
            @infoList.changePosition(@infoList.currentPosition + 1)
          end
        when Input::UP
          pbPlayDecisionSE
          move = (@infoList.elementCount() / 2.0).ceil
          @infoList.changePosition(@infoList.currentPosition - move)
        when Input::DOWN
          pbPlayDecisionSE
          move = (@infoList.elementCount() / 2.0).ceil
          if @infoList.currentPosition == cutoff and @infoList.elementCount == 5
            @infoList.changePosition(4)
          else
            @infoList.changePosition(@infoList.currentPosition + move)
          end
        when Input::USE
          if seen and infoElems[@infoList.currentElement()][:SelectText]
            pbPlayDecisionSE
            msgBox = pbCreateMessageWindow()
            infoElems[@infoList.currentElement()][:SelectText].each{ |line|
              self.messageDisplay(msgBox, line){
                pbUpdateSpriteHash(@@sprites)
              }
            }
            pbDisposeMessageWindow(msgBox)
          end
        when Input::BACK
          pbPlayCloseMenuSE
          @@sprites[:SelectBox].visible = false
          @@sprites[:LeftArrow].visible = false
          @@sprites[:RightArrow].visible = false
          msgBox = pbCreateMessageWindow()
          self.messageDisplay(msgBox, "", true, nil, false, false){
            background -= 1
            @background.setBackground(background)
            pbUpdateSpriteHash(@@sprites)
            break if background == 0
          }
          pbDisposeMessageWindow(msgBox)
          return
        end
      end
    end
  end
end
