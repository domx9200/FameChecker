module FameChecker
  class FameList
    attr_reader :positionList
    attr_reader :currentPosition
    attr_reader :maximumPosition

    include FameChecker
    def initialize()
      @@sprites[:list] = Sprite.new(@@vp)
      @@sprites[:list].bitmap = Bitmap.new(1024,1024)
      @@sprites[:list].bitmap.clear
      @@sprites[:list].z = -1
      @@sprites[:list].x = 15
      @@sprites[:list].y = 44

      @@sprites[:upListArrow] = AnimatedSprite.create("Graphics/Pictures/FameChecker/UI/upArrow.png", 4, 4, @@vp)
      @@sprites[:upListArrow].play
      @@sprites[:upListArrow].x = 67
      @@sprites[:upListArrow].y = 33

      @@sprites[:downListArrow] = AnimatedSprite.create("Graphics/Pictures/FameChecker/UI/downArrow.png", 4, 4, @@vp)
      @@sprites[:downListArrow].play
      @@sprites[:downListArrow].x = 67
      @@sprites[:downListArrow].y = 41 + (@@sprites[:listBackground].bitmap.height)

      @@sprites[:selectListArrow] = Sprite.new(@@vp)
      @@sprites[:selectListArrow].z = 1
      @@sprites[:selectListArrow].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/UI/listArrow.png")
      @@sprites[:selectListArrow].src_rect.width = @@sprites[:selectListArrow].src_rect.width / 2
      @@sprites[:selectListArrow].x = 18
      @@sprites[:selectListArrow].y = 50

      defaultTextPaddingReset = -4
      betweenYPadding = 4
      textHeight = 22
      @totalYPadding = textHeight + defaultTextPaddingReset + betweenYPadding

      @baseListTextColor = Color.new(96, 96, 96)
      @baseListTextShadow = Color.new(208, 208, 200)
      @selectListTextColor = Color.new(32, 152, 8)
      @selectListTextShadow = Color.new(144, 240, 144)

      @currentPosition = 0
      @positionList = []
      @maximumPosition = 0
      @visibleWindow = [0, 9]
      self.redrawListText()
      self.updateArrowVisibility()
      pbUpdateSpriteHash(@@sprites)
    end

    def redrawListText()
      @@sprites[:list].bitmap.clear
      startingXPadding = 18
      startingYPadding = Essentials::VERSION == "19.1" ? 0 : 4
      x = 0 + startingXPadding
      y = 0 + startingYPadding
      pos = 0
      @positionList = []
      @@compiledData.each { |name, values|
        seen = $PokemonGlobal.FamousPeople[name][:HasBeenSeen]
        if seen
          text = $PokemonGlobal.FamousPeople[name][:Name] ? $PokemonGlobal.FamousPeople[name][:Name] : values[:Name]
          textSize = @@sprites[:list].bitmap.text_size(text)
          pbDrawShadowText(@@sprites[:list].bitmap, x, y, textSize.width, textSize.height, text.upcase, pos != @currentPosition ? @baseListTextColor : @selectListTextColor, pos != @currentPosition ? @baseListTextShadow : @selectListTextShadow)
          @positionList.push(name)
          y += @totalYPadding
          pos += 1
        end
      }
      textSize = @@sprites[:list].bitmap.text_size("CANCEL")
      pbDrawShadowText(@@sprites[:list].bitmap, x, y, textSize.width, textSize.height, "CANCEL", pos != @currentPosition ? @baseListTextColor : @selectListTextColor, pos != @currentPosition ? @baseListTextShadow : @selectListTextShadow)
      @positionList.push(:CANCEL)
      @maximumPosition = pos
    end

    def shiftListDown()
      return -1 if @currentPosition == @maximumPosition
      @currentPosition += 1
      self.redrawListText()
      @@sprites[:selectListArrow].y += @totalYPadding if @currentPosition <= @visibleWindow[1]

      return @positionList[@currentPosition] if @currentPosition <= @visibleWindow[1]
      # change the y position of sprites[:list] to reveal the name below, move the sprite up.
      @@sprites[:list].y = @@sprites[:list].y - @totalYPadding
      @visibleWindow[0] += 1
      @visibleWindow[1] += 1
      self.updateArrowVisibility()
      return @positionList[@currentPosition]
    end

    def shiftListUp()
      return -1 if @currentPosition == 0
      @currentPosition -= 1
      self.redrawListText()
      @@sprites[:selectListArrow].y -= @totalYPadding if @currentPosition >= @visibleWindow[0]

      return @positionList[@currentPosition] if @currentPosition >= @visibleWindow[0]
      # change the y position of sprites[:list] to reveal the name above, move the sprite down.
      @@sprites[:list].y = @@sprites[:list].y + @totalYPadding
      @visibleWindow[0] -= 1
      @visibleWindow[1] -= 1
      self.updateArrowVisibility()
      return @positionList[@currentPosition]
    end

    def updateArrowVisibility()
      @@sprites[:upListArrow].visible = false
      @@sprites[:downListArrow].visible = false
      @@sprites[:upListArrow].visible = true if @visibleWindow[0] > 0
      @@sprites[:downListArrow].visible = true if @visibleWindow[1] < @maximumPosition
    end

    def swapListArrowTexture()
      if @@sprites[:selectListArrow].src_rect.x == 0
        @@sprites[:selectListArrow].src_rect.x = @@sprites[:selectListArrow].src_rect.width
      else
        @@sprites[:selectListArrow].src_rect.x = 0
      end
    end

    def getCurrentPosition()
      return @positionList[@currentPosition]
    end
  end
end
