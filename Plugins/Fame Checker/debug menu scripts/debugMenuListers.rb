class FameLister
  def initialize(selection = 0)
    @sprite = Sprite.new(nil)
    @sprite.x = Graphics.width * 3 / 4
    @sprite.y = Graphics.height / 2
    @sprite.z = 2
    @selection = selection
    @commands = []
    @values = []
    @index = 0
  end

  def dispose()
    @sprite.bitmap.dispose if @sprite.bitmap
    @sprite.dispose
  end

  def setViewport(vp)
    @sprite.viewport = vp
  end

  def startIndex()
    return @index
  end

  def commands()
    @commands.clear
    @values.clear
    cmds = []
    FameChecker.compiledData.each { |key, hash|
      cmds.push([key, key.to_s])
    }
    cmds.sort! {|a, b| a[1].downcase <=> b[1].downcase}
    @commands.push(_INTL("[NEW FAMOUS PERSON]"))
    @values.push(true)
    cmds.each { |elem|
      @commands.push(sprintf("%s", elem[1]))
      @values.push(elem[0])
    }
    @index = @selection
    @index = @commands.length - 1 if @index >= @commands.length
    @index = 0 if @index < 0
    return @commands
  end

  def value(index = @index)
    return nil if index < 0
    return @values[index]
  end

  def refresh(index = @index)
    @sprite.bitmap.dispose if @sprite.bitmap
    return if index < 0
    begin
      if @values[index].is_a?(Symbol)
        @sprite.bitmap = Bitmap.new(FameChecker.compiledData[@values[index]][:SpriteLocation])
      else
        @sprite.bitmap = nil
      end
    rescue
      @sprite.bitmap = nil
    end
    if @sprite.bitmap
      @sprite.ox = @sprite.bitmap.width / 2
      @sprite.oy = @sprite.bitmap.height / 2
    end
    return
  end
end

class FameInfoLister
  def initialize(fameData, selection = 0)
    @fameData = fameData
    @sprite = nil
    @selection = selection
    @commands = []
    @index = 0
    @vp = nil
  end

  def dispose()
    return if not @sprite
    @sprite.bitmap.dispose if @sprite.bitmap
    @sprite.dispose
  end

  def setViewport(vp)
    @vp = vp
  end

  def startIndex()
    return @index
  end

  def commands()
    @commands.clear
    @commands.push(_INTL("[NEW INFO]"))
    @fameData = [] if @fameData == nil
    @fameData.each { |elem|
      @commands.push(sprintf("%s", elem[:Key].to_s))
    }
    @index = @selection
    @index = @commands.length - 1 if @index >= @commands.length
    @index = 0 if @index < 0
    return @commands
  end

  def value(index = @index)
    return nil if index < 0
    return true if index == 0
    return index - 1
  end

  def refresh(index = @index)
    @sprite.dispose if @sprite
    return if index < 0
    begin
      if index > 0
        info = @fameData[index - 1]
        frameSize = info[:FrameSize]
        frameShow = info[:FramesToShow]
        @sprite = FameChecker::InfoSprite.new(info[:SpriteLocation], info[:NumFrames], frameSize[0], frameSize[1],
                                  info[:FrameSkip], frameShow[0], frameShow[1], @vp)
      else
        @sprite = Sprite.new(@vp)
      end
    rescue
      @sprite = Sprite.new(@vp)
    end
    @sprite.x = Graphics.width * 3 / 4
    @sprite.y = Graphics.height / 2
    @sprite.z = 2
    return
  end
end
