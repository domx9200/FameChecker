module FameChecker
  class InfoSprite < AnimatedSprite
    attr_reader :frameBegin
    attr_reader :frameEnd

    def initialize(animName, frameCount, frameWidth, frameHeight, frameSkip, frameBegin, frameEnd, vp = nil)
      super(animName, frameCount, frameWidth, frameHeight, frameSkip, vp)
      @frameBegin = frameBegin
      @frameEnd = frameEnd
      self.frame = @frameBegin
    end

    def update()
      super
      if self.frame > @frameEnd and @playing
        self.frame = @frameBegin
      end
    end
  end
end
