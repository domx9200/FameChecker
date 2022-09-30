module FameChecker
  class Background
    include FameChecker
    def initialize(starterFrame = 0)
      folder = "Graphics/Pictures/FameChecker"
      @@sprites[:background] = Sprite.new(@@vp)
      @@sprites[:background].z = 0
      self.setBackground(starterFrame)

      # x 15: y 48
      @@sprites[:listBackground] = Sprite.new(@@vp)
      @@sprites[:listBackground].bitmap = Bitmap.new("#{folder}/BG/bgList.png")
      @@sprites[:listBackground].z = -2
      @@sprites[:listBackground].x = 15
      @@sprites[:listBackground].y = 46
      
      #  x 235: y 232
      @@sprites[:infoTextBackground] = Sprite.new(@@vp)
      @@sprites[:infoTextBackground].bitmap = Bitmap.new("#{folder}/BG/bgInfoText.png")
      @@sprites[:infoTextBackground].z = -2
      @@sprites[:infoTextBackground].x = 235
      @@sprites[:infoTextBackground].y = 232

      @@sprites[:bigSpriteButton] = Sprite.new(@@vp)
      @@sprites[:cancelButton] = Sprite.new(@@vp)
      @@sprites[:checkInfoButton] = Sprite.new(@@vp)
      @@sprites[:infoSelectButton] = Sprite.new(@@vp)
      @@sprites[:listSelectButton] = Sprite.new(@@vp)
      @@sprites[:readInfoButton] = Sprite.new(@@vp)

      @@sprites[:bigSpriteButton].bitmap = Bitmap.new("#{folder}/Buttons/bigSprite.png")
      @@sprites[:cancelButton].bitmap = Bitmap.new("#{folder}/Buttons/cancel.png")
      @@sprites[:checkInfoButton].bitmap = Bitmap.new("#{folder}/Buttons/checkInfo.png")
      @@sprites[:infoSelectButton].bitmap = Bitmap.new("#{folder}/Buttons/infoSelect.png")
      @@sprites[:listSelectButton].bitmap = Bitmap.new("#{folder}/Buttons/listSelect.png")
      @@sprites[:readInfoButton].bitmap = Bitmap.new("#{folder}/Buttons/readInfo.png")
      self.setButtons()
    end

    def setBackground(frame)
      @@sprites[:background].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/BG/bgFrame#{frame}.png")
    end

    def setButtons(buttons = [])
      @@sprites[:bigSpriteButton].visible = false
      @@sprites[:cancelButton].visible = false
      @@sprites[:checkInfoButton].visible = false
      @@sprites[:infoSelectButton].visible = false
      @@sprites[:listSelectButton].visible = false
      @@sprites[:readInfoButton].visible = false

      x = Graphics.width
      y = 9
      padding = 9
      buttons.each { |button|
        x = x - padding - @@sprites[button].bitmap.width
        @@sprites[button].x = x
        @@sprites[button].y = y
        @@sprites[button].visible = true
      }
    end
  end
end