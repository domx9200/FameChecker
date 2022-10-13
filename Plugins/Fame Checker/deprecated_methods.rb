module FameChecker
  def self.create()
    puts("FameChecker.create has been deprecated and will be removed when Essentials v21 releases,\nplease change your usage to the new function replacing it: FameChecker.startFameChecker")
    self.startFameChecker()
  end

  def self.hasEncountered(famePerson, seen = true)
    puts("FameChecker.hasEncountered has been deprecated and will be removed when Essentials v21 releases,\nplease change your usage to the new function replacing it: FameChecker.setFameSeen")
    self.setFameSeen(famePerson, seen)
  end

  def self.hasFoundInfo(famePerson, info, seen = true)
    puts("FameChecker.hasFoundInfo has been deprecated and will be removed when Essentials v21 releases,\nplease change your usage to the new function replacing it: FameChecker.setFameInfoSeen")
    self.setFameInfoSeen(famePerson, info, seen)
  end

  def self.printFoundStatus(famePerson)
    puts("FameChecker.printFoundStatus has been deprecated and will be removed when Essentials v21 releases,\nplease change your usage to the new function replacing it: FameChecker.fameStatus?")
    return self.fameStatus?(famePerson)
  end

  def self.createFamousPerson(*args)
    puts("FameChecker.createFamousPerson has been deprecated and will be removed when Essentials v21 releases")
  end

  def self.createFameInfo(*args)
    puts("FameChecker.createFameInfo has been deprecated and will be removed when Essentials v21 releases")
  end

  def self.setupFamousPeople()
    puts("FameChecker.setupFamousPeople has been deprecated and will be removed when Essentials v21 releases")
  end

  def self.setupFameInfo()
    puts("FameChecker.setupFameInfo has been deprecated and will be removed when Essentials v21 releases")
  end
end
