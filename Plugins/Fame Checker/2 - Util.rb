module FameChecker
  class FC
    def setXY(sprite, x, y)
      @sprites[sprite].x = x
      @sprites[sprite].y = y
    end

    def setX(sprite, x)
      @sprites[sprite].x = x
    end

    def setY(sprite, y)
      @sprites[sprite].y = y
    end

    def setSourceRectXY(sprite, x, y)
      @sprites[sprite].src_rect.x = x
      @sprites[sprite].src_rect.y = y
    end

    def setSourceRectX(sprite, x)
      @sprites[sprite].src_rect.x = x
    end

    def setSourceRectY(sprite, y)
      @sprites[sprite].src_rect.y = y
    end

    def setSourceRectSize(sprite, width, height)
      @sprites[sprite].src_rect.width = width
      @sprites[sprite].src_rect.height = height
    end

    def setSourceRectWidth(sprite, width)
      @sprites[sprite].src_rect.width = width
    end

    def setSourceRectHeight(sprite, height)
      @sprites[sprite].src_rect.height = height
    end

    def setCenterPointXY(sprite, x, y)
      @sprites[sprite].ox = x
      @sprites[sprite].oy = y
    end

    def setCenterPointX(sprite, x)
      @sprites[sprite].ox
    end

    def setCenterPointY(sprite, y)
      @sprites[sprite].oy
    end

    def playSE(soundToPlay)
      soundToPlay == 0 ? pbPlayDecisionSE : pbPlayCloseMenuSE
    end

    # code to ensure that all sprites created are deleted properly
    # this is to help the game run better in the long run
    def dispose(id = nil)
      id.nil? ? pbDisposeSpriteHash(@sprites) : pbDisposeSprite(@sprites,id)
    end

    # updates the graphics and input so that the screen actually displays
    # will be called a lot
    def update()
      Graphics.update
      Input.update
      pbUpdateSpriteHash(@sprites)
    end

    def atListEdge()
      return 1 if @currentPos == 0
      return 2 if @currentPos == @max
      return 0
    end
  end

  def self.checkSetup()
    if !$PokemonGlobal.FameTargets
      $PokemonGlobal.FameTargets = {}
    end

    if !$PokemonGlobal.FameInfo
      $PokemonGlobal.FameInfo = {}
    end
  end

  def self.runSetup()
    puts(@@calledSetup)
    if !@@calledSetup
      FameChecker.setupFamousPeople()
      FameChecker.setupFameInfo()
      @@calledSetup = true
    end
    puts(@@calledSetup)
  end
end