module FameChecker
  def self.startFameChecker()
    pbFadeOutIn {
      runtimeHandler = RuntimeHandler.new
      runtimeHandler.run()
      FameChecker.cleanup()
    }
  end
end