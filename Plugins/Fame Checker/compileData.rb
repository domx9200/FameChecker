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
    "FramesToShow" => [:FramesToShow, "*u"],
    "FrameSkip" => [:FrameSkip, "u"],
    "FrameSize" => [:FrameSize, "*u"],
    "IsAnimated" => [:IsAnimated, "b"],
    "MiddleScreenText" => [:MiddleScreenText, "*s"],
    "HoverText" => [:HoverText, "s"],
    "SelectText" => [:SelectText, "*s"]
  }

  def self.compile(mustCompile = false)
    return if !$DEBUG or not safeIsDirectory?(COMPILE_FOLDER)
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
    onFame = true
    currentFame = nil
    currentHash = nil
    currentInfo = nil
    lineNo = 0

    File.open("#{COMPILE_FOLDER}/fame_targets.txt", "r") do |file|
      for line in file.readlines()
        lineNo += 1
        line = Compiler::prepline(line)
        next if line[/^\s*$/]

        m = line.match(/^\s*\[\s*(.+)\s*\]$/)
        if m
          if onFame
            self.ensureRequiredData(data, currentFame) if currentFame
            raise _INTL("#{m[1].to_sym} already exists, having multiple entries will cause major problems") if data[m[1].to_sym] != nil
            data[m[1].to_sym] = {}
            currentFame = m[1].to_sym
            data[currentFame][:Complete] = [0, 0] if !data[currentFame][:Complete]
            data[currentFame][:FameLookup] = {}
          else
            self.ensureInfoSizeData(currentFame, currentHash, currentInfo) if currentHash
            raise _INTL("#{m[1].to_sym} already exists for #{currentFame},\nhaving multiple of the same will cause major problems") if data[currentFame][:FameLookup][m[1].to_sym] != nil
            data[currentFame][:Complete][1] += 1
            data[currentFame][:FameInfo] = [] if !data[currentFame][:FameInfo]
            data[currentFame][:FameInfo].push({})
            data[currentFame][:FameLookup] = {} if !data[currentFame][:FameLookup]
            currentHash = data[currentFame][:FameInfo][data[currentFame][:FameInfo].length - 1]
            data[currentFame][:FameLookup][m[1].to_sym] = data[currentFame][:FameInfo].length - 1
            currentInfo = m[1].to_sym
          end
          next
        end

        m = line.match(/^\s*(\w+)\s*=\s*(.*)\s*$/)
        if m and m[2] != ""
          if m[1] == "FameInfo" and m[2] == "{"
            onFame = false
          else
            mapFromSchema(onFame ? data[currentFame] : currentHash, m[2],
                          onFame ? FamousPersonSchema[m[1]] : FameInfoSchema[m[1]], lineNo)
            if m[1] == "HasBeenSeen" and !onFame and currentHash[:HasBeenSeen]
              data[currentFame][:Complete][0] += 1
            end
          end
          next
        end

        m = line.match(/^\s*}\s*$/)
        if m
          onFame = true
        end
      end
    end

    return data
  end
end
