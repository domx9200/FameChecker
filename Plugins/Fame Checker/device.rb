module FameChecker
  class Device
    attr_reader :deviceIn
    include FameChecker
    def initialize()
      @@sprites[:device] = Sprite.new(@@vp)
      @@sprites[:device].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/UI/Device.png")
      @@sprites[:device].z = 2
      @@sprites[:device].x = Graphics.width
      @@sprites[:device].y = 40

      @endX = Graphics.width - @@sprites[:device].bitmap.width
      @deviceBallCenterPoint = [323, 93]
      @deviceMoveAmount = @@sprites[:device].bitmap.width / 35
      @deviceScreenSize = [222, 164]
      @deviceScreenCorner = [44, 10]

      @@sprites[:deviceBall] = Sprite.new(@@vp)
      @@sprites[:deviceBall].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/UI/spinningPokeball.png")
      @@sprites[:deviceBall].z = 3
      bitmap = @@sprites[:deviceBall].bitmap
      @@sprites[:deviceBall].ox = bitmap.width / 2
      @@sprites[:deviceBall].oy = bitmap.height / 2
      @@sprites[:deviceBall].x = Graphics.width + @deviceBallCenterPoint[0]
      @@sprites[:deviceBall].y = 40 + @deviceBallCenterPoint[1]

      @@sprites[:deviceSprite] = Sprite.new(@@vp)
      @@sprites[:deviceSprite].z = 3

      @deviceIn = false
    end

    def moveDeviceIn()
      while @@sprites[:device].x > @endX
        @@sprites[:device].x -= @deviceMoveAmount
        @@sprites[:deviceBall].x -= @deviceMoveAmount
        @@sprites[:deviceSprite].x -= @deviceMoveAmount
        @@sprites[:deviceBall].angle += 5
        Graphics.update if @@sprites[:device].x > @endX
      end
      diff = @endX - @@sprites[:device].x
      @@sprites[:device].x += diff
      @@sprites[:deviceBall].x += diff
      @@sprites[:deviceSprite].x += diff
      Graphics.update
      @deviceIn = true
    end

    def moveDeviceOut()
      while @@sprites[:device].x < Graphics.width
        @@sprites[:device].x += @deviceMoveAmount
        @@sprites[:deviceBall].x += @deviceMoveAmount
        @@sprites[:deviceSprite].x += @deviceMoveAmount
        @@sprites[:deviceBall].angle += 5
        Graphics.update if @@sprites[:device].x < Graphics.width
      end
      diff = @@sprites[:device].x - Graphics.width
      @@sprites[:device].x -= diff
      @@sprites[:deviceBall].x -= diff
      @@sprites[:deviceSprite].x -= diff
      Graphics.update
      @deviceIn = false
    end

    def setDeviceSprite(famousPerson)
      if not @@compiledData[famousPerson]
        @@sprites[:deviceSprite].bitmap.clear if @@sprites[:deviceSprite].bitmap
        return
      end
      @@sprites[:deviceSprite].bitmap = Bitmap.new(@@compiledData[famousPerson][:SpriteLocation])
      bitmap = @@sprites[:deviceSprite].bitmap
      @@sprites[:deviceSprite].ox = bitmap.width / 2
      @@sprites[:deviceSprite].oy = bitmap.height / 2
      offset = [0, 0]
      if @@compiledData[famousPerson][:SpriteOffset]
        offset = @@compiledData[famousPerson][:SpriteOffset]
      end
      @@sprites[:deviceSprite].x = @@sprites[:device].x + @deviceScreenCorner[0] + @deviceScreenSize[0] / 2 + offset[0]
      @@sprites[:deviceSprite].y = @@sprites[:device].y + @deviceScreenCorner[1] + @deviceScreenSize[1] / 2 + offset[1]
    end
  end
end
