module FameChecker
  FamousPersonSchema = {
    "Name" => [:Name, "s"],
    "HasBeenSeen" => [:HasBeenSeen, "b"],
    "SpriteLocation" => [:SpriteLocation, "s"],
    "SpriteOffset" => [:SpriteOffset, "*i"]
  }

  FameInfoSchema = {
    "SpriteLocation" => [:SpriteLocation, "s"],
    "HasBeenSeen" => [:HasBeenSeen, "b"],
    "Frames" => [:NumFrames, "u"],
    "NumFrames" => [:NumFrames, "u"],
    "FramesToShow" => [:FramesToShow, "*u"],
    "FrameSkip" => [:FrameSkip, "u"],
    "FrameSize" => [:FrameSize, "*u"],
    "IsAnimated" => [:IsAnimated, "b"],
    "MiddleScreenText" => [:MiddleScreenText, "*s"],
    "HoverText" => [:HoverText, "s"],
    "SelectText" => [:SelectText, "*s"]
  }

  #-------------------------------------------------------------------------#
  #                 Compile Functions                                       #
  #-------------------------------------------------------------------------#
  def self.compile(mustCompile = false)
    return if !$DEBUG or not safeIsDirectory?(COMPILE_FOLDER)
    if !safeExists?("#{COMPILE_FOLDER}/fame_targets.txt")
      self.generatePBS()
    end

    pbSetWindowText("Compiling Fame Checker data")
    refresh = mustCompile
    refresh = true if !safeExists?("Data/fame_targets.dat")
    refresh = true if Input.press?(Input::CTRL)
    refresh = true if !refresh and safeExists?("#{COMPILE_FOLDER}/fame_targets.txt") and
      File.mtime("#{COMPILE_FOLDER}/fame_targets.txt") > File.mtime("Data/fame_targets.dat")

    if refresh
      echoln "Compiling Fame Checker data...\n"
      data = self.compile_Fame_Targets()
      if not data
        raise _INTL("Compilation of Fame Checker data failed, fame_targets.txt may not exist or #{COMPILE_FOLDER} may not exist.")
      end
      save_data(data, "Data/fame_targets.dat")
      puts("Fame Checker data compiled successfully.")
      @@compiledThisLaunch = true
    end
    pbSetWindowText(nil)
  end

  def self.recompile()
    write_fame_targets()
    puts "\nUpdating Data/fame_targets.dat..."
    data = compile_Fame_Targets()
    save_data(data, "Data/fame_targets.dat") if data != nil
    if data == nil
      puts "Compiling Failed, somehow couldn't find the file that was written to."
      return
    end
    puts "Compiling of new fame_targets.dat successful.\n" if data != nil
    puts "Reloading compiled data..."
    ensureCompiledData(true)
    puts "Compiled Data reloaded."
  end

  def self.seperateCommaValues(str, type)
    outputs = [""]
    pos = 0
    inQuotes = false
    str.scan(/./) do |c|
      case c
      when "\""
        inQuotes = (not inQuotes)
      when " "
        outputs[pos] += c if type == "s"
      when ","
        if not inQuotes
          outputs.push("")
          pos += 1
        else
          outputs[pos] += c
        end
      else
        outputs[pos] += c
      end
    end
    outputs.each{ |element|
      Compiler::prepline(element)
    }
    return outputs
  end

  def self.mapFromSchema(hash, value, schema, lineNo)
    return if !schema
    multi = false
    type = nil
    seperatedValues = nil
    if schema[1].length > 1
      multi = true
      type = schema[1][1]
    else
      type = schema[1]
    end
    seperatedValues = seperateCommaValues(value, type) if multi
    case type
    when "s"
      if not seperatedValues
        value.gsub!(/"/, "") # remove quotes if the there is only one string
        hash[schema[0]] = value
      else
        hash[schema[0]] = seperatedValues
      end
    when "b"
      if value[/^1|[Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]|[Yy]$/]
        hash[schema[0]] = true
      elsif value[/^0|[Ff][Aa][Ll][Ss][Ee]|[Nn][Oo]|[Nn]$/]
        hash[schema[0]] = false
      else
        raise _INTL("Field #{schema[0]} at line #{lineNo} within fame_targets.txt is not a Boolean value, please provide true, yes, y, or 1 for true or false, no, n, or 0 for false values.\r\n")
      end
    when "i"
      if seperatedValues
        hash[schema[0]] = []
        for i in seperatedValues
          if !i[/^\-?\d+$/]
            raise _INTL("Field #{schema[0]} at line #{lineNo} within fame_targets.txt is not an Integer value")
          end
          hash[schema[0]].push(i.to_i)
        end
      else
        if !value[/^\-?\d+$/]
          raise _INTL("Field #{schema[0]} at line #{lineNo} within fame_targets.txt is not an Integer value")
        end
        hash[schema[0]] = (value.to_i)
      end
    when "u"
      if seperatedValues
        hash[schema[0]] = []
        for u in seperatedValues
          if !u[/^\d+$/]
            raise _INTL("Field #{schema[0]} at line #{lineNo} within fame_targets.txt is not a positive Integer value")
          end
          hash[schema[0]].push(u.to_i)
        end
      else
        if !value[/^\d+$/]
          raise _INTL("Field #{schema[0]} at line #{lineNo} within fame_targets.txt is not a positive Integer value")
        end
        hash[schema[0]] = (value.to_i)
      end
    end
  end

  def self.ensureInfoSizeData(currentFame, infoHash, name)
    raise _INTL("#{name} under #{currentFame} was never provided a SpriteLocation, this is required\n") if not infoHash[:SpriteLocation]
    File.open(infoHash[:SpriteLocation], "rb") rescue raise _INTL("#{name} under #{currentFame} was provided a SpriteLocation, however the file doesn't exist or is a folder.\n")
    infoHash[:IsAnimated] = false if not infoHash[:IsAnimated]
    if infoHash[:IsAnimated]
      infoHash[:NumFrames] = 16 if not infoHash[:NumFrames] # assume is default setup
      infoHash[:FramesToShow] = [0, 3] if not infoHash[:FramesToShow] # assume front facing sprites are 0 to 3
      infoHash[:FrameSkip] = 4 if not infoHash[:FrameSkip] # 4 is slow enough that most animations would be fine
      bm = Bitmap.new(infoHash[:SpriteLocation])
      frameSize = [bm.width / 4, bm.height / 4] # calculate the frame size based on input sprite
      infoHash[:FrameSize] = frameSize if not infoHash[:FrameSize]
    else
      infoHash[:NumFrames] = 1 if not infoHash[:NumFrames]
      infoHash[:FramesToShow] = [0, 0] if not infoHash[:FramesToShow]
      infoHash[:FrameSkip] = 0 if not infoHash[:FrameSkip]
      bm = Bitmap.new(infoHash[:SpriteLocation])
      infoHash[:FrameSize] = [bm.width, bm.height] if not infoHash[:FrameSize]
    end
    infoHash[:MiddleScreenText] = ["", ""] if not infoHash[:MiddleScreenText]
    infoHash[:HoverText] = "" if not infoHash[:HoverText]
    infoHash[:SelectText] = [""] if not infoHash[:SelectText]
  end

  def self.ensureRequiredData(data, currentFame)
    data[currentFame][:Name] = currentFame.to_s if not data[currentFame][:Name]
    data[currentFame][:HasBeenSeen] = false if not data[currentFame][:HasBeenSeen]
    data[currentFame][:SpriteOffset] = [0, 0] if not data[currentFame][:SpriteOffset]
    raise _INTL("#{currentFame} was never provided a SpriteLocation, this is required\n") if not data[currentFame][:SpriteLocation]
    File.open(data[currentFame][:SpriteLocation], "rb") # rescue raise _INTL("#{currentFame} was provided a SpriteLocation, however the file doesn't exist or is a folder.\n")
  end

  def self.compile_Fame_Targets()
    return nil if !safeExists?("#{COMPILE_FOLDER}/fame_targets.txt")
    data = {}
    currentFame = nil
    lineNo = -1
    File.open("#{COMPILE_FOLDER}/fame_targets.txt") do |file|
      line = ""
      while line != nil
        line = Compiler::prepline(line)
        if line[/^#*$/]
          lineNo += 1
          line = file.gets()
          next
        end

        m = line.match(/^\s*\[\s*(.+)\s*\]$/)
        if m
          self.ensureRequiredData(data, currentFame) if currentFame
          raise _INTL("#{m[1].to_sym} already exists, having multiple entries will cause major problems") if data[m[1].to_sym] != nil
          data[m[1].to_sym] = {}
          currentFame = m[1].to_sym
          data[currentFame][:Complete] = [0, 0]
          data[currentFame][:FameLookup] = {}
        end

        m = line.match(/^\s*(\w+)\s*=\s*(.*)\s*$/)
        if m
          raise _INTL("First non commented line of fame_targets.txt was not a [], Data will be unusable") if currentFame == nil
          if m[1] == "FameInfo" and m[2] == "{"
            self.compile_Fame_Info(currentFame, file, data, lineNo)
          else
            self.mapFromSchema(data[currentFame], m[2], FamousPersonSchema[m[1]], lineNo)
          end
        end
        lineNo += 1
        line = file.gets()
      end
      self.ensureRequiredData(data, currentFame)
    end
    return data
  end

  def self.compile_Fame_Info(famousPerson, file, data, lineNo)
    hash = nil
    line = file.gets()
    return if line == nil
    while line != nil
      line = Compiler::prepline(line)
      if line[/^#*$/]
        lineNo += 1
        line = file.gets()
        next
      end

      m = line.match(/^\s*\[\s*(.+)\s*\]$/)
      if m
        self.ensureInfoSizeData(famousPerson, hash, hash[:Key]) if hash
        raise _INTL("#{m[1].to_sym} already exists for #{famousPerson},\nhaving multiple of the same will cause major problems") if data[famousPerson][:FameLookup][m[1].to_sym] != nil
        data[famousPerson][:Complete][1] += 1
        data[famousPerson][:FameInfo] = [] if not data[famousPerson][:FameInfo]
        data[famousPerson][:FameInfo].push({})
        data[famousPerson][:FameInfo].last[:Key] = m[1].to_sym
        hash = data[famousPerson][:FameInfo].last
        data[famousPerson][:FameLookup][m[1].to_sym] = data[famousPerson][:FameInfo].length - 1
      end

      m = line.match(/^\s*(\w+)\s*=\s*(.*)\s*$/)
      if m
        raise _INTL("#{famousPerson}'s FameInfo section doesn't begin with a [], this will cause major problems") if hash == nil
        mapFromSchema(hash, m[2], FameInfoSchema[m[1]], lineNo)
        if m[1] == "HasBeenSeen" and hash[:HasBeenSeen]
          data[famousPerson][:Complete][0] += 1
        end
      end

      m = line.match(/^\s*}\s*$/)
      if m
        self.ensureInfoSizeData(famousPerson, hash, hash[:Key])
        lineNo += 1
        return
      end

      line = file.gets()
      lineNo += 1
    end
    self.ensureInfoSizeData(famousPerson, hash, hash[:Key])
  end

  def self.generateDefaultData()
    return {
      :OAK => {
        :Name => "Oak",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/OAK.png",
        :SpriteOffset => [-2, 0],
        :FameInfo => [
          {
            :Key => :EXPERIMENT,
            :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
            :HasBeenSeen => false,
            :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
            :HoverText => "Did you hear about his secret experiment...?",
            :SelectText => ["Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"]
          },
          {
            :Key => :EXPERIMENT2,
            :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/4.png",
            :HasBeenSeen => true,
            :MiddleScreenText => ["CITY", "GYM SIGN"],
            :HoverText => "Did you hear, about his secret experiment...?",
            :SelectText => ["Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"]
          },
          {
            :Key => :RUNNER,
            :SpriteLocation => "Graphics/Characters/boy_run.png",
            :HasBeenSeen => true,
            :IsAnimated => true,
            :MiddleScreenText => ["CITY", "GYM SIGN"],
            :HoverText => "Did you hear, about his secret experiment...?",
            :SelectText => ["Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"]
          }
        ]
      },
      :DAISY => {
        :Name => "Daisy",
        :HasBeenSeen => true,
        :SpriteLocation => "Graphics/Pictures/FameChecker/DeviceSprites/DAISY.png",
        :FameInfo => [
          {
            :Key => :EXPERIMENT,
            :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/GymSign.png",
            :HasBeenSeen => true,
            :NumFrames => 1,
            :FramesToShow => [0, 0],
            :FrameSkip => 0,
            :FrameSize => [64, 64],
            :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
            :HoverText => "Did you hear about his secret experiment...?",
            :SelectText => ["Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"]
          },
          {
            :Key => :EXPERIMENT2,
            :SpriteLocation => "Graphics/Pictures/FameChecker/SmallSprites/4.png",
            :HasBeenSeen => true,
            :NumFrames => 1,
            :FramesToShow => [0, 0],
            :FrameSkip => 0,
            :FrameSize => [26, 38],
            :MiddleScreenText => ["VERIDIAN CITY", "GYM SIGN"],
            :HoverText => "Did you hear about his secret experiment...?",
            :SelectText => ["Oak is an interesting man, he apparently created MISSINGNO!", "I get it, you're skeptical, but it's true, he really did!"]
          }
        ]
      }
    }
  end

  def self.generatePBS()
    puts "fame_targets.txt doesn't exist within #{COMPILE_FOLDER}, generating a new one...\n"
    @@compiledData = safeExists?("Data/fame_targets.dat") ? load_data("Data/fame_targets.dat") : self.generateDefaultData()
    self.write_fame_targets()
    @@compiledData = nil
    puts "new fame_targets.txt successfully generated\n"
  end

  #-------------------------------------------------------------------------#
  #                 Write Functions                                         #
  #-------------------------------------------------------------------------#
  def self.writeFameTargetsHeader(file)
    file.write("#-------------------------------------------------\n")
    file.write("# input options, famous person:\n")
    file.write("# [Name], this is required for creating new people, each must be unique\n")
    file.write("# Name = string, not required, can pull from [Name]\n")
    file.write("# HasBeenSeen = boolean, not required, defaults false\n")
    file.write("# SpriteLocation = string(file location), required and it needs to lead to an actual file\n")
    file.write("# SpriteOffset = Int, Int, not required, defaults 0, 0\n")
    file.write("# FameInfo = {, not required, however is necessary if you want to also put in fame info.\n")
    file.write("#\tyou must end this section with } on a new line\n")
    file.write("#\n")
    file.write("# input options, famous info\n")
    file.write("# [Name], this is required for creating new pieces of info, each must be unique\n")
    file.write("# SpriteLocation = string(file location), required and it needs to lead to an actual file\n")
    file.write("# HasBeenSeen = boolean, not required, defaults false\n")
    file.write("# IsAnimated = boolean, not required, defaults false\n")
    file.write("# Frames = positive int, not required, defaults to 0 or 16 based on if IsAnimated is true or not\n")
    file.write("#\tNumFrames is equivalent to Frames, both can be used\n")
    file.write("# FramesToShow = positive int, positive int, not required, defaults to 0, 0 or 0, 3 based on if IsAnimated is true or not\n")
    file.write("# FrameSkip = positive int, not required, defaults to 0 or 4 based on if IsAnimated is true or not\n")
    file.write("# FrameSize = positive int, positive int, not required, either is the whole file size if IsAnimated is false, and is equal to the size / sqrt(Frames).ceil() ex => Frames = 15, sqrt(Frames).ceil() = 4\n")
    file.write("# MiddleScreenText = string, string, not required, defaults to \"\", \"\"\n")
    file.write("# HoverText = string, not required, defaults to \"\"\n")
    file.write("# SelectText = any number of strings, not required, defaults to \"\"\n")
    file.write("#\n")
    file.write("# Since everything is comma seperated, make sure you use quotes your sentences if you want to include , within your text\n")
    file.write("# HoverText doesn't need to be in quotes no matter if you include , in it\n")
    file.write("#-------------------------------------------------\n")
  end

  def self.writeBySchema(file, value, schema, tab = false)
    multi = schema[1][0] == "*" ? true : false
    type = schema[1][multi ? 1 : 0]
    tab = tab ? "\t" : ""
    file.write("#{tab}#{schema[0].to_s}=")
    case type
    when "b"
      file.write("#{value}\n")
    when "i"
      if not multi
        file.write("#{value}\n")
      else
        size = value.length
        for i in 0...size
          file.write("#{value[i]}")
          file.write(",") if i != size - 1
          file.write("\n") if i == size - 1
        end
      end
    when "s"
      if not multi
        file.write("#{value}\n")
      else
        size = value.length
        for i in 0...size
          file.write("\"#{value[i]}\"")
          file.write(",") if i != size - 1
          file.write("\n") if i == size - 1
        end
      end
    when "u"
      if not multi
        file.write("#{value}\n")
      else
        size = value.length
        for i in 0...size
          file.write("#{value[i]}")
          file.write(",") if i != size - 1
          file.write("\n") if i == size - 1
        end
      end
    else
      file.write("\n")
    end
  end

  def self.write_fame_info(file, fameArray)
    file.write("FameInfo = {\n")
    fameArray.each{ |elem|
      file.write("\t[#{elem[:Key].to_s}]\n")
      elem.each{ |key, val|
        next if key == :Key
        next if not FameInfoSchema[key.to_s]
        schem = FameInfoSchema[key.to_s]
        writeBySchema(file, val, schem, true)
      }
      file.write("\t#------------------------------------------\n")
    }
    file.write("}\n")
  end

  def self.write_fame_targets()
    return if @@compiledData == nil
    puts "Begin writing fame_targets.txt within #{COMPILE_FOLDER}..."
    filePath = "#{COMPILE_FOLDER}/fame_targets.txt"
    File.open("#{filePath}", "w"){ |file|
      writeFameTargetsHeader(file)
      @@compiledData.each{ |key, val|
        file.write("[#{key.to_s}]\n")
        val.each{ |k, v|
          if k == :FameInfo
            write_fame_info(file, v)
            next
          end
          next if not FamousPersonSchema[k.to_s]
          schem = FamousPersonSchema[k.to_s]
          writeBySchema(file, v, schem)
        }
        file.write("#------------------------------------------\n")
      }
    }
    puts "\nFile successfully written to."
  end
end
