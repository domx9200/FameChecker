module FameChecker
  class RuntimeHandler
    include FameChecker
    # defines the base elements, including the other needed objects for runtime
    def initialize()
      
      @@vp = Viewport.new(0,0,Graphics.width,Graphics.height)
      @@vp.z = 99999
      @@sprites = {}
      
      #-----------TO BE REMOVED-------------------------------------
      $PokemonGlobal.FamousPeople = {}
      $PokemonGlobal.FamousPeople[:OAK] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/testfront.png",
        :FameInfo => [{
          :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
          :HasBeenSeen => true,
          :FrameSize => [64, 64],
          :FramesToShow => [0, 0],
          :NumFrames => 1,
          :FrameSkip => 0,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "Did you hear about his secret experiment...",
          :SelectText => ["Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"]
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["CITY", "GYM SIGN"],
          :HoverText => "test"
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["VERIDIAN", "GYM SIGN"],
          :HoverText => "test 2"
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 3"
        },{
          :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
          :HasBeenSeen => true,
          :FrameSize => [64, 64],
          :FramesToShow => [0, 0],
          :NumFrames => 1,
          :FrameSkip => 0,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 4"
        },{
          :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
          :HasBeenSeen => true,
          :FrameSize => [64, 64],
          :FramesToShow => [0, 0],
          :NumFrames => 1,
          :FrameSkip => 0,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 5"
        },{
          :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
          :HasBeenSeen => true,
          :FrameSize => [64, 64],
          :FramesToShow => [0, 0],
          :NumFrames => 1,
          :FrameSkip => 0,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "Did you hear about his secret experiment..."
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test"
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 2"
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 3"
        },{
          :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
          :HasBeenSeen => true,
          :FrameSize => [64, 64],
          :FramesToShow => [0, 0],
          :NumFrames => 1,
          :FrameSkip => 0,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 4"
        },{
          :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
          :HasBeenSeen => true,
          :FrameSize => [64, 64],
          :FramesToShow => [0, 0],
          :NumFrames => 1,
          :FrameSkip => 0,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 5"
        },{
          :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
          :HasBeenSeen => true,
          :FrameSize => [64, 64],
          :FramesToShow => [0, 0],
          :NumFrames => 1,
          :FrameSkip => 0,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "Did you hear about his secret experiment..."
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test"
        },{
          :SpriteLocation => "Graphics/Characters/boy_run.png",
          :HasBeenSeen => true,
          :FrameSize => [32, 48],
          :FramesToShow => [0, 3],
          :NumFrames => 16,
          :FrameSkip => 4,
          :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
          :HoverText => "test 2"
        }]
      }
      $PokemonGlobal.FamousPeople[:OAK2] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK3] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK4] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK5] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK6] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK7] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK8] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK9] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK10] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK11] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      $PokemonGlobal.FamousPeople[:OAK12] = {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0]
      }
      #-----------END TO BE REMOVED---------------------------------
      
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
          self.runInfoList()
          mode = :FameList
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
          message = currentFame == :CANCEL ? "CANCEL" : $PokemonGlobal.FamousPeople[currentFame][:Name].upcase
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
            break if !@device.deviceIn and !@infoList.noElems
          end
        }
        pbDisposeMessageWindow(msgBox)
        input = messageOutput if messageOutput == Input::USE or messageOutput == Input::BACK

        case input
        when Input::UP
          ret = @fameList.shiftListUp()
          if ret != -1
            currentFame = ret 
            @device.setDeviceSprite(currentFame)
            @infoList.setFamousPerson(currentFame, true)
          end
        when Input::DOWN
          ret = @fameList.shiftListDown()
          if ret != -1
            currentFame = ret 
            @device.setDeviceSprite(currentFame)
            @infoList.setFamousPerson(currentFame)
          end
        when Input::USE
          return :InfoList
        when Input::ACTION
          if !@device.deviceIn
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
      infoElems = $PokemonGlobal.FamousPeople[@infoList.currentInfoPerson][:FameInfo]
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
        message = infoElems[@infoList.currentElement][:HoverText] and infoElems[@infoList.currentElement][:HasBeenSeen] ? infoElems[@infoList.currentElement][:HoverText] : ""
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
          if changePage
            @infoList.changePageLeft()
            cutoff = @infoList.elementCount() > 3 ? (@infoList.elementCount() / 2.0).ceil - 1 : -1
          else
            @infoList.changePosition(@infoList.currentPosition - 1)
          end
        when Input::RIGHT
          if changePage
            @infoList.changePageRight()
            cutoff = @infoList.elementCount() > 3 ? (@infoList.elementCount() / 2.0).ceil - 1 : -1
          else
            @infoList.changePosition(@infoList.currentPosition + 1)
          end
        when Input::UP
          move = (@infoList.elementCount() / 2.0).ceil
          @infoList.changePosition(@infoList.currentPosition - move)
        when Input::DOWN
          move = (@infoList.elementCount() / 2.0).ceil
          if @infoList.currentPosition == cutoff and @infoList.elementCount == 5
            @infoList.changePosition(4)
          else
            @infoList.changePosition(@infoList.currentPosition + move)
          end
        when Input::USE
          if infoElems[@infoList.currentElement()][:HasBeenSeen] and infoElems[@infoList.currentElement()][:SelectText]
            msgBox = pbCreateMessageWindow()
            infoElems[@infoList.currentElement()][:SelectText].each{ |line|
              self.messageDisplay(msgBox, line){
                pbUpdateSpriteHash(@@sprites)
              }
            }
            pbDisposeMessageWindow(msgBox)
          end
        when Input::BACK
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

# pbUpdateSpriteHash(@@sprites)
#       msgBox = pbCreateMessageWindow()
#       input = 0
#       self.messageDisplay(msgBox, "This will be the test text"){
#         pbUpdateSpriteHash(@@sprites)
#         if Input.trigger?(Input::LEFT)
#           input = Input::LEFT
#           break
#         end
#       }
#       self.messageDisplay(msgBox, "")
#       pbDisposeMessageWindow(msgBox)
#       puts("TODO RuntimeHandler.run")
#       background = 0
#       deviceInView = false
#       @device.setDeviceSprite(:OAK)
#       currentPos = 0
#       currentPage = 1
#       loop do
#         pbUpdateSpriteHash(@@sprites)
#         Graphics.update
#         Input.update
#         @@sprites[:deviceBall].angle += 5
#         if Input.trigger?(Input::LEFT)
#           @@sprites[:RightArrow].x -= 1
#           puts("#{@@sprites[:RightArrow].x}:#{@@sprites[:RightArrow].y}")
#         elsif Input.trigger?(Input::RIGHT)
#           @@sprites[:RightArrow].x += 1
#           puts("#{@@sprites[:RightArrow].x}:#{@@sprites[:RightArrow].y}")
#         elsif Input.trigger?(Input::UP)
#           @@sprites[:RightArrow].y -= 1
#           puts("#{@@sprites[:RightArrow].x}:#{@@sprites[:RightArrow].y}")
#         elsif Input.trigger?(Input::DOWN)
#           @@sprites[:RightArrow].y += 1
#           puts("#{@@sprites[:RightArrow].x}:#{@@sprites[:RightArrow].y}")
#         end
#         if Input.trigger?(Input::BACK)
#           if currentPage > 1
#             currentPage = @infoList.changePageLeft()
#           # if background == 2
#           #   2.times{
#           #     background -= 1
#           #     @background.setBackground(background)
#           #     pbUpdateSpriteHash(@@sprites)
#           #     Graphics.update
#           #   }
#           else
#             break
#           end
#         # elsif Input.trigger?(Input::UP)
#         #   output = @fameList.shiftListUp()
#         #   if output != -1
#         #     @device.setDeviceSprite(output)
#         #   end
#         # elsif Input.trigger?(Input::DOWN)
#         #   output = @fameList.shiftListDown()
#         #   if output != -1
#         #     @device.setDeviceSprite(output)
#         #   end
#         elsif Input.trigger?(Input::USE)
#         #   if not deviceInView
#         #     @device.moveDeviceIn()
#         #     deviceInView = true
#         #   else
#         #     @device.moveDeviceOut()
#         #     deviceInView = false
#         #   end
#           # @fameList.swapListArrowTexture()
#           # if background == 0
#           #   2.times{
#           #     background += 1
#           #     @background.setBackground(background)
#           #     pbUpdateSpriteHash(@@sprites)
#           #     Graphics.update
#           #   }
#           # end
#           # currentPos += 1
#           # currentPos = 0 if currentPos > 5
#           # @infoList.changePosition(currentPos)
#           if currentPage < @infoList.maxPages
#             currentPage = @infoList.changePageRight()
#           end
#         end
#         # if Input.trigger?(Input::USE)
#         #   if background == 0
#         #     2.times{
#         #       background += 1
#         #       @background.setBackground(background)
#         #       pbUpdateSpriteHash(@@sprites)
#         #       Graphics.update
#         #     }
#         #   end
#         # elsif Input.trigger?(Input::BACK)
#         #   if background == 2
#         #     2.times{
#         #       background -= 1
#         #       @background.setBackground(background)
#         #       pbUpdateSpriteHash(@@sprites)
#         #       Graphics.update
#         #     }
#         #   else
#         #     break
#         #   end
#         # end
#       end