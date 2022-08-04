module FameChecker
  class FC
    def createSprite(spriteName, activeFolder = nil, fileName = nil,  dir = "Graphics/Pictures/FameChecker")
      @sprites[spriteName] = Sprite.new(@vp) if !@sprites[spriteName]
      #puts("#{dir}/#{activeFolder}/#{fileName}")
      if !activeFolder || !fileName
        @sprites[spriteName].bitmap = Bitmap.new(512, 512)
      else
        @sprites[spriteName].bitmap = Bitmap.new("#{dir}/#{activeFolder}/#{fileName}")
      end
    end

    def changeBitmap(spriteName, activeFolder, fileName, dir = "Graphics/Pictures/FameChecker")
      return if !@sprites[spriteName]
      @sprites[spriteName].bitmap = Bitmap.new("#{dir}/#{activeFolder}/#{fileName}")
    end

    def clearBitmap(spriteName)
      return if !@sprites[spriteName]
      @sprites[spriteName].bitmap.clear
    end

    def createAnimSprite(spriteName, numFrames, frameSkip, fileName)
      return if @sprites[spriteName]
      @sprites[spriteName] = AnimatedSprite.create(fileName, numFrames, frameSkip, @vp)
    end

    def makeGreyscale(spriteName)
      return if !@sprites[spriteName]
      @sprites[spriteName].tone = Tone.new(0,0,0,140)
      @sprites[spriteName].color = Color.new(0,0,0,140)
    end

    def makeClear(spriteName)
      return if !@sprites[spriteName]
      @sprites[spriteName].tone = Tone.new(0,0,0,0)
      @sprites[spriteName].color = Color.new(0,0,0,0)
    end

    #--------------------------------------------------------------------------------------------------------------
    #                                         BACKGROUND ELEMENTS                                                 |
    #--------------------------------------------------------------------------------------------------------------

    # openState references the state the info box is open, 
    # 0 = closed, 1 = slightly open, 2 = fully open
    # dir is the directory the code will look in for the textures
    # folder is the exact folder it will look in
    def setBackground(openState = 0, dir = "Graphics/Pictures/FameChecker", folder = "bg")
      fileName  = openState == 0 ? "closed_bg" : openState == 1 ? "mid_open_bg.png" : "full_open_bg.png"
      self.createSprite("bg", folder, fileName, dir)
    end

    def setInfoBox(x = @baseInfoBoxX, y = @baseInfoBoxY, dir = "Graphics/Pictures/FameChecker", folder = "bg")
      self.createSprite("infoBox", folder, "open_info.png", dir)
      self.setXY("infoBox", x, y)
      @sprites["infoBox"].z = -2
    end

    def setListBox(x = @baseListX, y = @baseListY, dir = "Graphics/Pictures/FameChecker", folder = "bg")
      self.createSprite("listBox", folder, "list.png", dir)
      self.setXY("listBox", x, y)
      @sprites["listBox"].z = -2
    end

    # files needs to be an array of strings representing the file names
    def setButtons(files, dir = "Graphics/Pictures/FameChecker", folder = "buttons" , x = @baseButtonX, y = @baseButtonY, padding = @baseButtonPadding)
      i = 0
      files.each {|file| 
        self.createSprite("button_#{i}", folder, file, dir)
        @sprites["button_#{i}"].z = 1
        x = x - padding - @sprites["button_#{i}"].bitmap.width
        self.setXY("button_#{i}", x, y)
        i = i + 1
      }

      i = files.length
      loop do
        if @sprites["button_#{i}"]
          self.dispose("button_#{i}")
          i += 1
        else
          break
        end
      end
    end

    #--------------------------------------------------------------------------------------------------------------
    #                                         MOVING ELEMENTS                                                     |
    #--------------------------------------------------------------------------------------------------------------

    def setListSelect(dir = "Graphics/Pictures/FameChecker", folder = "UI")
      self.createSprite("listSelect", folder, "list_arrow.png", dir)
      @sprites["listSelect"].z = 1
      self.setSourceRectWidth("listSelect", @sprites["listSelect"].bitmap.width / 2)
      self.setXY("listSelect", 18, @baseListY + 9) if @namePosList[0]
      @sprites["listSelect"].visible = false if !@namePosList[0]
    end

    # since we will need more than one in some cases this function is set up to
    # both create and rotate when needed
    # direction is like so
    # 0 = UP, 1 = DOWN , 2 = LEFT, 3 = RIGHT
    def setBigArrow(spriteName, direction = 0, dir = "Graphics/Pictures/FameChecker", folder = "UI")
      return if direction < 0 || direction > 3
      fileName = direction == 0 ? "upArrow" : direction == 1 ? "downArrow" : direction == 2 ? "leftArrow" : "rightArrow"
      self.createAnimSprite(spriteName, 4, 4, "#{dir}/#{folder}/#{fileName}")
      @sprites[spriteName].z = 1
      @sprites[spriteName].visible = false
    end

    # currently, max number of display-able names is 6
    def positionListArrow(up)
      return false if up && @currentPos == 0
      return false if !up && @currentPos == @max

      if @currentPos == @displayedMax && !up
        @currentPos += 1
        @displayedMax += 1
        @displayedMin += 1
        self.shiftList(false)
        if @max <= @displayedMax
          @sprites["downListArrow"].visible = false
        end

        if @displayedMin > 0
          @sprites["upListArrow"].visible = true
        end
        return true
      end

      if @currentPos == @displayedMin && up
        @currentPos -= 1
        @displayedMax -= 1
        @displayedMin -= 1
        self.shiftList(true)
        if @max > @displayedMax
          @sprites["downListArrow"].visible = true
        end

        if @displayedMin <= 0
          @sprites["upListArrow"].visible = false
        end
        return true
      end

      if !up
        sprite = @sprites["listSelect"]
        y = sprite.y
        y += @sprites["listSelect"].bitmap.text_size("t").height + 4
        sprite.y = y
        @sprites["listSelect"] = sprite
        @currentPos += 1
        self.drawListText
        return true
      end

      sprite = @sprites["listSelect"]
      y = sprite.y
      y -= @sprites["listSelect"].bitmap.text_size("t").height + 4
      sprite.y = y
      @sprites["listSelect"] = sprite
      @currentPos -= 1
      self.drawListText
      return true
    end

    def swapListArrowTexture()
      if @sprites["listSelect"].src_rect.x == 0
        self.setSourceRectX("listSelect", @sprites["listSelect"].bitmap.width / 2) 
      else
        self.setSourceRectX("listSelect", 0)
      end
    end

    #--------------------------------------------------------------------------------------------------------------
    #                                         DEVICE ELEMENTS                                                     |
    #--------------------------------------------------------------------------------------------------------------

    def setDevice(spriteName, dir = "Graphics/Pictures/FameChecker", folder = "UI")
      self.createSprite(spriteName, folder, "device.png", dir)
      @sprites[spriteName].z = 2
      @deviceXEnd = Graphics.width - @sprites[spriteName].bitmap.width
      self.setXY(spriteName, @baseDeviceX, @baseDeviceY)
    end

    # this function will be called whenever the big sprite needs to be changed, 
    # the create sprite will be skipped most of the time
    # The center point is set to make positioning really easy
    def setBigSprite(spriteName, folder = "Big_Sprites", charFile = nil, dir = "Graphics/Pictures/FameChecker")
      if !charFile
        self.createSprite(spriteName)
      else
        self.createSprite(spriteName, folder, charFile, dir)
      end
      @sprites[spriteName].z = 3
      bitmap = @sprites[spriteName].bitmap
      self.setCenterPointXY(spriteName, bitmap.width / 2, bitmap.height / 2)
      #puts("#{@sprites[spriteName].ox}, #{@sprites[spriteName].oy}")
      self.setXY(spriteName, @baseDeviceX + @deviceScreenCorner[0] + (@deviceScreenSize[0] / 2), @baseDeviceY + @deviceScreenCorner[1] + (@deviceScreenSize[1] / 2))
    end

    def setDeviceBall(spriteName, dir = "Graphics/Pictures/FameChecker", folder = "UI")
      self.createSprite(spriteName, folder, "spinning_pokeball.png", dir)
      @sprites[spriteName].z = 3
      bitmap = @sprites[spriteName].bitmap
      self.setCenterPointXY(spriteName, bitmap.width / 2, bitmap.height / 2)
      self.setXY(spriteName, @baseDeviceX + @spinBallCenterPoint[0], @baseDeviceY + @spinBallCenterPoint[1])
    end

    def moveDeviceSprites(devSprite, spriteList, x)
      return if !@sprites[devSprite] 
      return if !@sprites[spriteList[0]] || !@sprites[spriteList[1]]
      xDiff = @sprites[devSprite].x - x
      self.setX(devSprite, x)
      spriteList.each{ |sprite|
        self.setX(sprite, @sprites[sprite].x - xDiff)
      }
    end


    #--------------------------------------------------------------------------------------------------------------
    #                                         INFO ELEMENTS                                                       |
    #--------------------------------------------------------------------------------------------------------------

    def displayInfoSprites(famousPerson, page = 1)
      return 0 if !$PokemonGlobal.FameInfo[famousPerson]
      infoElem = $PokemonGlobal.FameInfo[famousPerson]

      pages = infoElem.size / 6 + 1 
      numToDisplay = infoElem.size % 6 # if zero, check to see if pages are zero
      return 0 if pages == 0 && numToDisplay == 0 # there is nothing to display if there are no pages nor any excess
      return 0 if pages < page

      self.disposeAll
      if numToDisplay == 0 && pages > 0 # if true set excess to 6, as 6 things should be displayed
        numToDisplay = 6
      end

      if pages > page
        numToDisplay = 6
      end
      input = []
      numToDisplay.times{ |i|
        input.push(infoElem[i + 6 * (page - 1)])
      }
      
      self.displayOneInfo(input) if numToDisplay == 1
      self.displayTwoInfo(input) if numToDisplay == 2
      self.displayThreeInfo(input) if numToDisplay == 3
      self.displayFourInfo(input) if numToDisplay == 4
      self.displayFiveInfo(input) if numToDisplay == 5
      self.displaySixInfo(input) if numToDisplay == 6
      @currentInfoPos = 0
      return numToDisplay
    end

    def displayOneInfo(element)
      self.createSprite("info0", "small_sprites", self.decideFile(element[0]))
      self.setCenterPointXY("info0", @sprites["info0"].bitmap.width / 2, @sprites["info0"].bitmap.height / 2)
      self.setXY("info0", @infoPosOne, @infoPosDefaultY)
      @numInfoDisplay = 1
    end

    def displayTwoInfo(infoElem)
      i = 0
      infoElem.each{ |element|
        self.createSprite("info#{i}", "small_sprites", self.decideFile(element))
        self.setCenterPointXY("info#{i}", @sprites["info#{i}"].bitmap.width / 2, @sprites["info#{i}"].bitmap.height / 2)
        self.setXY("info#{i}", @infoPosTwo[i], @infoPosDefaultY)
        i += 1
      }
      @numInfoDisplay = 2
    end

    def displayThreeInfo(infoElem)
      i = 0
      infoElem.each{ |element|
        self.createSprite("info#{i}", "small_sprites", self.decideFile(element))
        self.setCenterPointXY("info#{i}", @sprites["info#{i}"].bitmap.width / 2, @sprites["info#{i}"].bitmap.height / 2)
        self.setXY("info#{i}", @infoPosThree[i], @infoPosDefaultY)
        i += 1
      }
      @numInfoDisplay = 3
    end

    def displayFourInfo(infoElem)
      i = 0
      infoElem.each{ |element|
        self.createSprite("info#{i}", "small_sprites", self.decideFile(element))
        self.setCenterPointXY("info#{i}", @sprites["info#{i}"].bitmap.width / 2, @sprites["info#{i}"].bitmap.height / 2)
        self.setXY("info#{i}", @infoPosTwo[i % 2], @infoPosDefaultY + (i < 2 ? -@infoUpShift : @infoDownShift))
        i += 1
      }
      @numInfoDisplay = 4
    end

    def displayFiveInfo(infoElem)
      i = 0
      infoElem.each{ |element|
        self.createSprite("info#{i}", "small_sprites", self.decideFile(element))
        self.setCenterPointXY("info#{i}", @sprites["info#{i}"].bitmap.width / 2, @sprites["info#{i}"].bitmap.height / 2)
        self.setXY("info#{i}", i < 3 ? @infoPosThree[i] : @infoPosTwo[i % 3], @infoPosDefaultY + (i < 3 ? -@infoUpShift : @infoDownShift))
        i += 1
      }
      @numInfoDisplay = 5
    end

    def displaySixInfo(infoElem)
      i = 0
      infoElem.each{ |element|
        self.createSprite("info#{i}", "small_sprites", self.decideFile(element))
        self.setCenterPointXY("info#{i}", @sprites["info#{i}"].bitmap.width / 2, @sprites["info#{i}"].bitmap.height / 2)
        self.setXY("info#{i}", @infoPosThree[i % 3], @infoPosDefaultY + (i < 3 ? -@infoUpShift : @infoDownShift))
        i += 1
      }
      @numInfoDisplay = 6
    end

    def disposeAll()
      6.times{ |num|
        self.dispose("info#{num}")
      }
    end

    def decideFile(elem)
      if elem["seen"]
        return elem["fileName"]
      else
        return "unknown.png"
      end
    end

    def setSelectBox()
      self.createAnimSprite("selectBox", 2, 5, "Graphics/Pictures/FameChecker/UI/select_box.png")
      @sprites["selectBox"].z = 1
      @sprites["selectBox"].visible = false
    end

    def setSelectBoxPos(infoPos)
      bm = @sprites["info#{infoPos}"]
      self.setXY("selectBox", bm.x - bm.bitmap.width / 2 - 5, bm.y - bm.bitmap.height / 2 - 5)
    end

    def makeInfoGreyScale(notGrey)
      6.times { |i|
        self.makeGreyscale("info#{i}") if i != notGrey
      }
    end

    def makeInfoClean()
      6.times { |i|
        self.makeClear("info#{i}")
      }
    end
  end
end
# 0-5 page 1
# 6-10 page 2
# 11-15 page 3