module FameChecker
  class InfoList
    attr_reader :currentPosition
    attr_reader :currentPage
    attr_reader :maxPages
    attr_reader :currentInfoPerson
    attr_reader :noElems

    include FameChecker
    def initialize()
      @unknownLocation = "Graphics/Pictures/FameChecker/SmallSprites/Unknown64x64.png"
      @noElems = false

      #---------------SELECT BOX---------------------------------------------------------------------
      # TODO change size of select box based on config
      @@sprites[:SelectBox] = AnimatedSprite.create("Graphics/Pictures/FameChecker/UI/SelectBox64x64.png", 2, 8, @@vp)
      @@sprites[:SelectBox].visible = false
      @@sprites[:SelectBox].play
      @selectBoxOffset = 5

      #---------------LEFT/RIGHT ARROWS---------------------------------------------------------------------
      @@sprites[:LeftArrow] = AnimatedSprite.create("Graphics/Pictures/FameChecker/UI/leftArrow.png", 4, 4, @@vp)
      @@sprites[:LeftArrow].visible = false
      @@sprites[:LeftArrow].play
      @@sprites[:LeftArrow].x = 160
      @@sprites[:LeftArrow].y = 118

      @@sprites[:RightArrow] = AnimatedSprite.create("Graphics/Pictures/FameChecker/UI/rightArrow.png", 4, 4, @@vp)
      @@sprites[:RightArrow].visible = false
      @@sprites[:RightArrow].play
      @@sprites[:RightArrow].x = 490
      @@sprites[:RightArrow].y = 118

      #---------------PAGE MANAGEMENT---------------------------------------------------------------------
      @maxPages = 0 # represents the max number of pages
      @currentPage = 0 # represents the current page
      @currentPosition = 0 # represents the current position within the current page
      @currentInfoPerson = nil # represents the current famous person
      @visibleElements = [] # represents the location of elements in the current famous person's FameInfo section

      #---------------POSITIONS---------------------------------------------------------------------
      # represents the base y position for sprites less than 4
      @baseY = 132

      # represents X positions
      @oneSprite = 341
      @twoSprite = [290, 390]
      @threeSprite = [250, 340, 432]

      # represents the y offset up and down
      @OffsetY = [-40, 40]

      #---------------MIDDLE TEXT---------------------------------------------------------------------
      @@sprites[:MidText] = Sprite.new(@@vp)
      @@sprites[:MidText].bitmap = Bitmap.new(208, 48)
      @@sprites[:MidText].x = 235
      @@sprites[:MidText].y = 232
      @@sprites[:MidText].z = -1
      @textColor = Color.new(96, 96, 96)
      @textShadow = Color.new(208, 208, 200)
      defaultTextPaddingReset = -4
      betweenYPadding = 4
      textHeight = 22
      @totalYPadding = textHeight + defaultTextPaddingReset + betweenYPadding
    end

    def setFamousPerson(famousPerson, allClear = false)
      if !@@compiledData[famousPerson] or !@@compiledData[famousPerson][:FameInfo]
        self.clearSprites()
        @@sprites[:SelectBox].visible = false
        @@sprites[:LeftArrow].visible = false
        @@sprites[:RightArrow].visible = false
        @@sprites[:MidText].bitmap.clear
        @noElems = true
        return 0
      end
      @noElems = false
      @maxPages = (@@compiledData[famousPerson][:FameInfo].length / 6.0).ceil
      @currentInfoPerson = famousPerson
      @currentPage = 1

      self.changeVisibleElements()
      self.displayInfoSprites(0, allClear)
      # self.updateArrowVisibility()
      return 1
    end

    #----------PAGE MANAGEMENT FUNCTIONS---------------------
    def changeVisibleElements()
      return -1 if @currentPage > @maxPages
      @visibleElements = []
      range = @currentPage < @maxPages ? 6 : @@compiledData[@currentInfoPerson][:FameInfo].length % 6
      range = 6 if range == 0
      @visibleElements.fill(0...range) {|i| i + 6 * (@currentPage - 1)}
    end

    def changePageLeft()
      return -1 if @currentPage == 1 or @currentInfoPerson == nil
      @currentPage -= 1
      self.changeVisibleElements()
      self.displayInfoSprites(@visibleElements.length - 1)
      self.updateArrowVisibility()
      return @currentPage
    end

    def changePageRight()
      return -1 if @currentPage == @maxPages or @currentInfoPerson == nil
      @currentPage += 1
      self.changeVisibleElements()
      self.displayInfoSprites()
      self.updateArrowVisibility()
      return @currentPage
    end

    #---------SPRITE FUNCTIONS--------------------------------
    def createInfoSprites()
      i = 0
      @visibleElements.each { |pos|
        if $PokemonGlobal.FamousPeople[@currentInfoPerson][:FameInfo][pos] == true
          element = @@compiledData[@currentInfoPerson][:FameInfo][pos]
          frameSize = element[:FrameSize]
          framesToShow = element[:FramesToShow]
          @@sprites["Info#{i}".to_sym] = InfoSprite.new(element[:SpriteLocation], element[:NumFrames], frameSize[0], frameSize[1],
                                                        element[:FrameSkip], framesToShow[0], framesToShow[1], @@vp)
        else
          @@sprites["Info#{i}".to_sym] = InfoSprite.new(@unknownLocation, 1, 64, 64, 0, 0, 0, @@vp)
        end
        i += 1
      }
    end

    def displayInfoSprites(currentPos = 0, allClear = false)
      return -1 if @currentInfoPerson == nil or !@@compiledData[@currentInfoPerson]
      return 0 if !@@compiledData[@currentInfoPerson][:FameInfo] or @@compiledData[@currentInfoPerson][:FameInfo].length == 0
      infoElem = @@compiledData[@currentInfoPerson][:FameInfo]

      self.clearSprites()
      self.createInfoSprites()

      case @visibleElements.length
      when 1
        self.displayOneInfo()
      when 2
        self.displayTwoInfo()
      when 3
        self.displayThreeInfo()
      when 4
        self.displayFourInfo()
      when 5
        self.displayFiveInfo()
      when 6
        self.displaySixInfo()
      end
      if self.changePosition(currentPos, allClear) == -1
        self.changePosition(0, allClear)
      end

      return @visibleElements.length
    end

    def displayOneInfo()
      @@sprites[:Info0].x = @oneSprite - @@sprites[:Info0].src_rect.width / 2
      @@sprites[:Info0].y = @baseY - @@sprites[:Info0].src_rect.height / 2
    end

    def displayTwoInfo()
      i = 0
      @visibleElements.each{ |element|
        @@sprites["Info#{i}".to_sym].x = @twoSprite[i] - @@sprites["Info#{i}".to_sym].src_rect.width / 2
        @@sprites["Info#{i}".to_sym].y = @baseY - @@sprites["Info#{i}".to_sym].src_rect.height / 2
        i += 1
      }
    end

    def displayThreeInfo()
      i = 0
      @visibleElements.each{ |element|
        @@sprites["Info#{i}".to_sym].x = @threeSprite[i] - @@sprites["Info#{i}".to_sym].src_rect.width / 2
        @@sprites["Info#{i}".to_sym].y = @baseY - @@sprites["Info#{i}".to_sym].src_rect.height / 2
        i += 1
      }
    end

    def displayFourInfo()
      i = 0
      @visibleElements.each{ |element|
        @@sprites["Info#{i}".to_sym].x = @twoSprite[i % 2] - @@sprites["Info#{i}".to_sym].src_rect.width / 2
        @@sprites["Info#{i}".to_sym].y = @baseY + (i < 2 ? @OffsetY[0] : @OffsetY[1]) - @@sprites["Info#{i}".to_sym].src_rect.height / 2
        i += 1
      }
    end

    def displayFiveInfo()
      i = 0
      @visibleElements.each{ |element|
        @@sprites["Info#{i}".to_sym].x = (i < 3 ? @threeSprite[i] : @twoSprite[i % 3]) - @@sprites["Info#{i}".to_sym].src_rect.width / 2
        @@sprites["Info#{i}".to_sym].y = @baseY + (i < 3 ? @OffsetY[0] : @OffsetY[1]) - @@sprites["Info#{i}".to_sym].src_rect.height / 2
        i += 1
      }
    end

    def displaySixInfo()
      i = 0
      @visibleElements.each{ |element|
        @@sprites["Info#{i}".to_sym].x = @threeSprite[i % 3] - @@sprites["Info#{i}".to_sym].src_rect.width / 2
        @@sprites["Info#{i}".to_sym].y = @baseY + (i < 3 ? @OffsetY[0] : @OffsetY[1]) - @@sprites["Info#{i}".to_sym].src_rect.height / 2
        i += 1
      }
    end

    def clearSprites()
      6.times { |i|
        if @@sprites["Info#{i}".to_sym]
          pbDisposeSprite(@@sprites, "Info#{i}".to_sym)
        end
      }
      pbUpdateSpriteHash(@@sprites)
    end

    def updateSelectBox()
      offset = [
        (64 - @@sprites["Info#{@currentPosition}".to_sym].src_rect.width) / 2,
        (64 - @@sprites["Info#{@currentPosition}".to_sym].src_rect.height) / 2
      ]

      @@sprites[:SelectBox].x = @@sprites["Info#{@currentPosition}".to_sym].x - @selectBoxOffset - offset[0]
      @@sprites[:SelectBox].y = @@sprites["Info#{@currentPosition}".to_sym].y - @selectBoxOffset - offset[1]
    end

    def updateArrowVisibility()
      return -1 if @currentPage < 1 or @currentPage > @maxPages
      @@sprites[:LeftArrow].visible = @currentPage > 1 ? true : false
      @@sprites[:RightArrow].visible = @currentPage < @maxPages ? true : false
    end

    def updateGrayScale(allClear = false)
      @visibleElements.length.times { |i|
        @@sprites["Info#{i}".to_sym].tone = (i != @currentPosition and !allClear) ? Tone.new(0, 0, 0, 240) : Tone.new(0, 0, 0, 0)
        @@sprites["Info#{i}".to_sym].color = (i != @currentPosition and !allClear) ? Color.new(0, 0, 0, 160) : Color.new(0, 0, 0, 0)
        if i != @currentPosition or allClear
          @@sprites["Info#{i}".to_sym].stop
          @@sprites["Info#{i}".to_sym].frame = @@sprites["Info#{i}".to_sym].frameBegin
        end
      }
    end

    #-------GENERAL FUNCTIONS----------------------
    def changePosition(newPosition, allClear = false)
      return -1 if newPosition < 0 or newPosition >= @visibleElements.length
      @currentPosition = newPosition
      self.updateSelectBox
      self.updateMiddleText
      @@sprites["Info#{newPosition}".to_sym].play
      self.updateGrayScale(allClear)
      return 0
    end

    def currentElement()
      return @visibleElements[@currentPosition]
    end

    def elementCount()
      return @visibleElements.length
    end

    #--------MIDDLE TEXT FUNCTIONS---------------------
    def updateMiddleText()
      fame = @@compiledData[@currentInfoPerson]
      return -1 if fame == nil
      elem = fame[:FameInfo][self.currentElement]
      return -1 if elem == nil# or elem[:MiddleScreenText] == nil
      @@sprites[:MidText].bitmap.clear
      return -1 if elem[:MiddleScreenText] == nil
      return 0 if !$PokemonGlobal.FamousPeople[@currentInfoPerson][:FameInfo][self.currentElement]
      startingXPadding = 104
      startingYPadding = Essentials::VERSION == "19.1" ? 0 : 4
      x = 0 + startingXPadding
      y = 0 + startingYPadding
      elem[:MiddleScreenText].each { |line|
        textSize = @@sprites[:MidText].bitmap.text_size(line)
        pbDrawShadowText(@@sprites[:MidText].bitmap, x - textSize.width / 2, y, textSize.width, textSize.height, line, @textColor, @shadowColor, 0)
        y += @totalYPadding
      }
    end
  end
end
