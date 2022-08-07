# code to initialize the save data
# also allows said data to be manipulated freely
class PokemonGlobalMetadata
  attr_accessor :FameTargets
  attr_accessor :FameInfo

  alias fame_checker_ini initialize
  def initialize
    fame_checker_ini
    @FameTargets = {}
    @FameInfo    = {}
  end
end
  
# standard use from bag action from base Essentials code
ItemHandlers::UseFromBag.add(:FAMECHECKER, proc { |item|
  next FameChecker.create ? 1 : 0
})
  
# can't be having FameChecker twice (though I think it's not going to error if you do), so the class will be called FC
# to keep them seperate enough
module FameChecker
  @@calledSetup = false
  class FC
    def defineVars()
      # misc values, all are really important, but not really
      # specifically related to anything
      @vp = Viewport.new(0,0,Graphics.width,Graphics.height)
      @vp.z = 99999
      @sprites = {}

      # text related values, though the first four pertain to the list
      @baseListTextColor = Color.new(96, 96, 96)
      @baseListTextShadow = Color.new(208, 208, 200)
      @selectListTextColor = Color.new(32, 152, 8)
      @selectListTextShadow = Color.new(144, 240, 144)
      @textDrawPaddingReset = -10

      # values for the name list on the left side of the screen
      @namePosList = {}
      @currentPos = 0
      @max = 0
      @displayedMin = 0
      @displayedMax = 5
      @listPos = 0
      @baseListX = 15
      @baseListY = 46
      @currentListY = 0 #@baseListY + @textDrawPaddingReset + 6

      # info box values
      @baseInfoBoxX = 245
      @baseInfoBoxY = 162

      # button values
      @baseButtonX = Graphics.width
      @baseButtonY = 9
      @baseButtonPadding = 9

      # device values
      @baseDeviceX = Graphics.width
      @baseDeviceY = 40
      @deviceXEnd = 0

      # big sprite values
      @deviceScreenSize = [210, 140]
      @deviceScreenCorner = [42, 24]

      # spinning Pokeball values
      # this value doesn't include the position of the device itself,
      # just the coordinates within the device to be drawn
      @spinBallCenterPoint = [323, 93]

      # info sprite values
      @currentInfoPos = 0
      @numInfoDisplay = 0

      # these values by default represent their positions in the middle of the grid, the functions
      # for having 4, 5, and 6 will use these values just adding or subtracting to the y value as needed
      @infoPosDefaultY = 106
      @infoPosOne = 350 # this dictates where the info sprite gets moved if there is only one
      @infoPosTwo = [301,398] # this dictates where the info sprites gets moved if there is only two
      @infoPosThree = [253, 350, 446] # this dictates where the info sprites gets moved if there is three 
      @infoDownShift = 16
      @infoUpShift = 32

      @infoArrowRightPos = [492, 84]
      @infoArrowLeftPos = [183, 84]
    end

    # creates the viewport, sprites hash, and other required variables
    # to initialize the screen to a usable state
    def setup()
      self.setBackground(0)
      self.setInfoBox
      self.setListBox

      bm = @sprites["infoBox"]
      self.createTextSprite("infoBoxText", bm.width, bm.height, -1)
      self.setXY("infoBoxText", @baseInfoBoxX - 20,@baseInfoBoxY)

      bm = @sprites["listBox"]
      self.createTextSprite("listText",  bm.width, bm.height, -1)
      self.setXY("listText", @baseListX, @baseListY)

      self.setDevice("device")
      self.setBigSprite("bigSprite")
      self.setDeviceBall("spinBall")

      self.drawListText()
      self.setListSelect()
      @listPos = @max

      self.setBigArrow("upListArrow",    0)
      self.setXY("upListArrow", @baseListX + @sprites["listBox"].bitmap.width / 2 - @sprites["upListArrow"].src_rect.width / 2, @baseListY - 7)
      self.setBigArrow("downListArrow",  1)
      self.setXY("downListArrow", @baseListX + @sprites["listBox"].bitmap.width / 2 - @sprites["upListArrow"].src_rect.width / 2, @baseListY + @sprites["listBox"].bitmap.height - 8)
      @sprites["downListArrow"].visible = true if @max > @displayedMax
      self.setBigArrow("rightListArrow", 3)
      self.setXY("rightListArrow", @infoArrowRightPos[0], @infoArrowRightPos[1])
      self.setBigArrow("leftListArrow", 2)
      self.setXY("leftListArrow", @infoArrowLeftPos[0], @infoArrowLeftPos[1])
      self.setSelectBox
    end
  end

  def self.create()
    FameChecker.checkSetup
    FameChecker.runSetup
    pbFadeOutIn{
      fc = FC.new
      fc.defineVars
      fc.setup
      fc.run
      fc.end
    }
    return true
  end
end