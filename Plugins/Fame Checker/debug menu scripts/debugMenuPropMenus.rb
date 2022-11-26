def fameTargetEditor()
  target_properties = [
    [_INTL("Key"), ReadOnlyProperty, _INTL("Internal name that is used as a symbol like :XXX.")],
    [_INTL("Name"), StringProperty, _INTL("Name of the target to be displayed in the Fame Checker window.")],
    [_INTL("SpriteLocation"), StringProperty, _INTL("The full path to the location of the sprite related to this target.")],
    [_INTL("HasBeenSeen"), BooleanProperty2, _INTL("The value that represents if the target has been seen by the player or not.")],
    [_INTL("SpriteOffset"), TwoIntegerProperty.new(true), _INTL("The value that represents the offset from the center of the device.")],
    [_INTL("FameInfo"), FameInfoProperty, _INTL("The value that represents the list of all Info related to the famous person.")],
    [_INTL("PlayerMessage"), StringArrayProperty, _INTL("The value that reperesents the message that will be played when the player has collected all pieces of info.")]
  ]

  new_target_properties = [
    [_INTL("Key"), StringProperty, _INTL("Internal name that is used as a symbol like :XXX.")],
    [_INTL("Name"), StringProperty, _INTL("Name of the target to be displayed in the Fame Checker window.")],
    [_INTL("SpriteLocation"), StringProperty, _INTL("The full path to the location of the sprite related to this target.")],
    [_INTL("HasBeenSeen"), BooleanProperty2, _INTL("The value that represents if the target has been seen by the player or not.")],
    [_INTL("SpriteOffset"), TwoIntegerProperty.new(true), _INTL("The value that represents the offset from the center of the device.")],
    [_INTL("PlayerMessage"), StringArrayProperty, _INTL("The value that reperesents the message that will be played when the player has collected all pieces of info.")]
  ]

  pbListScreenBlock(_INTL("Famous People"), FameLister.new()) { |button, index|
    if button == Input::ACTION
      if index.is_a?(Symbol)
        if pbConfirmMessageSerious("Delete this fame target?")
          FameChecker.compiledData.delete(index)
        end
      end
    elsif button == Input::USE
      if index.is_a?(Symbol)
        fame = FameChecker.compiledData[index]
        data = []
        if fame
          data.push(index)
          data.push(fame[:Name])
          data.push(fame[:SpriteLocation])
          data.push(fame[:HasBeenSeen])
          data.push(fame[:SpriteOffset])
          data.push([fame[:FameInfo].dup, index])
          data.push(fame[:PlayerMessage])
        end
        ret = pbPropertyList("#{index}'s data", data, target_properties, true)
        if ret == true
          fame[:Name] = data[1] == "" ? "???" : data[1]
          fame[:SpriteLocation] = data[2] == "" ? fame[:SpriteLocation] : data[2]
          fame[:HasBeenSeen] = data[3] == nil ? false : data[3]
          fame[:SpriteOffset] = data[4]
          fame[:FameInfo] = data[5][0] if (data[5][0] and !data[5][0].empty?)
          fame[:PlayerMessage] = data[6].length > 0 ? data[6] : fame[:PlayerMessage]
        end
      elsif index == true
        data = [
          "DEFAULTKEY",
          "???",
          "File/Path/Goes/Here",
          false,
          [0,0],
          [""]
        ]
        ret = pbPropertyList("New Fame Target", data, new_target_properties, true)
        if ret == true
          dat = {}
          newHash = {}
          newHash[:Name] = data[1]
          newHash[:SpriteLocation] = data[2]
          newHash[:HasBeenSeen] = data[3]
          newHash[:SpriteOffset] = data[4]
          newHash[:PlayerMessage] = data[5]
          dat[data[0].to_sym] = newHash
          FameChecker.ensureRequiredData(dat, data[0].to_sym)
          FameChecker.compiledData[data[0].to_sym] = dat[data[0].to_sym]
          FameChecker.recompile()
        end
      end
    end
  }
  FameChecker.recompile()
end

def fameInfoEditor(famousData)
  famousData[0] = [] if famousData[0] == nil
  info_properties = [
    [_INTL("Key"), ReadOnlyProperty, _INTL("Internal name that is used as a symbol like :XXX.")],
    [_INTL("SpriteLocation"), StringProperty, _INTL("The full path to the location of the sprite related to this piece of info.")],
    [_INTL("HasBeenSeen"), BooleanProperty2, _INTL("The value that represents if the info has been seen by the player or not.")],
    [_INTL("IsAnimated"), BooleanProperty2, _INTL("The value that represents if the info is animated in the info list.")],
    [_INTL("MiddleScreenText"), StringArrayLimitProperty.new(2), _INTL("The value that represents the text in the middle of the screen.")],
    [_INTL("HoverText"), StringProperty, _INTL("The value that represents the text that displaying while selecting a piece of info.")],
    [_INTL("SelectText"), StringArrayProperty, _INTL("The value that represents the text that displays when the user selects this piece of info.")],
    [_INTL("Frames"), UIntProperty.new(3), _INTL("The value that represents the number of frames within the provided sprites. Set this value to 0 if you want the program to decide for you.")],
    [_INTL("FramesToShow"), TwoIntegerProperty.new(false), _INTL("The value that represents the start and stop point of frames. Set these values to 0 if you want the program to decide for you.")],
    [_INTL("FrameSkip"), UIntProperty.new(2), _INTL("The value that represents how long it takes for the next frame to play. Set this value to 0 if you want the program to decide for you.")],
    [_INTL("FrameSize"), TwoIntegerProperty.new(false), _INTL("The value that represents the size of each individual frame. Set these values to 0 if you want the program to decide for you.")]
  ]

  new_info_properties = [
    [_INTL("Key"), StringProperty, _INTL("Internal name that is used as a symbol like :XXX.")],
    [_INTL("SpriteLocation"), StringProperty, _INTL("The full path to the location of the sprite related to this piece of info.")],
    [_INTL("HasBeenSeen"), BooleanProperty2, _INTL("The value that represents if the info has been seen by the player or not.")],
    [_INTL("IsAnimated"), BooleanProperty2, _INTL("The value that represents if the info is animated in the info list.")],
    [_INTL("MiddleScreenText"), StringArrayLimitProperty.new(2), _INTL("The value that represents the text in the middle of the screen.")],
    [_INTL("HoverText"), StringProperty, _INTL("The value that represents the text that displaying while selecting a piece of info.")],
    [_INTL("SelectText"), StringArrayProperty, _INTL("The value that represents the text that displays when the user selects this piece of info.")],
    [_INTL("Frames"), UIntProperty.new(3), _INTL("The value that represents the number of frames within the provided sprites. Set this value to 0 if you want the program to decide for you.")],
    [_INTL("FramesToShow"), TwoIntegerProperty.new(false), _INTL("The value that represents the start and stop point of frames. Set these values to 0 if you want the program to decide for you.")],
    [_INTL("FrameSkip"), UIntProperty.new(2), _INTL("The value that represents how long it takes for the next frame to play. Set this value to 0 if you want the program to decide for you.")],
    [_INTL("FrameSize"), TwoIntegerProperty.new(false), _INTL("The value that represents the size of each individual frame. Set these values to 0 if you want the program to decide for you.")]
  ]

  pbListScreenBlock(_INTL("#{famousData[1]}'s Info"), FameInfoLister.new(famousData[0])) { |button, index|
    if button == Input::ACTION
      if index.is_a?(Integer) and index >= 0
        if pbConfirmMessageSerious("Delete this piece of Info?")
          famousData[0].delete_at(index)
        end
      end
    elsif button == Input::USE
      if index.is_a?(Integer) and index >= 0
        data = [
          famousData[0][index][:Key].to_s,
          famousData[0][index][:SpriteLocation],
          famousData[0][index][:HasBeenSeen],
          famousData[0][index][:IsAnimated],
          famousData[0][index][:MiddleScreenText],
          famousData[0][index][:HoverText],
          famousData[0][index][:SelectText],
          famousData[0][index][:Frames],
          famousData[0][index][:FramesToShow],
          famousData[0][index][:FrameSkip],
          famousData[0][index][:FrameSize]
        ]

        ret = pbPropertyList(_INTL("#{famousData[0][index][:Key].to_s}"), data, info_properties, true)
        if ret == true
          famousData[0][index][:SpriteLocation] = data[1] == "" ? famousData[0][index][:SpriteLocation] : data[1]
          famousData[0][index][:HasBeenSeen] = data[2] == nil ? false : data[2]
          famousData[0][index][:IsAnimated] = data[3] == nil ? false : data[3]
          famousData[0][index][:MiddleScreenText] = data[4]
          famousData[0][index][:HoverText] = data[5]
          famousData[0][index][:SelectText] = data[6]
          famousData[0][index][:Frames] = data[7] != 0 ? data[7] : nil
          famousData[0][index][:FramesToShow] = data[8] != [0,0] ? data[8] : nil
          famousData[0][index][:FrameSkip] =  data[9] != 0 ? data[9] : nil
          famousData[0][index][:FrameSize] = data[10] != [0,0] ? data[10] : nil
          FameChecker.ensureInfoSizeData(famousData[1], famousData[0][index], data[0])
        end
      elsif index == true
        data = [
          "DEFAULTKEY",
          "File/Path/Goes/Here",
          false,
          false,
          ["",""],
          "",
          [""],
          0,
          [0,0],
          0,
          [0,0]
        ]
        ret = pbPropertyList(_INTL("New Info Element"), data, new_info_properties, true)
        if ret == true
          famousData[0].push({})
          elem = famousData[0].last
          elem[:Key] = data[0] != "" ? data[0].upcase.to_sym : "DEFUALTKEY"
          elem[:SpriteLocation] = data[1] == "" ? nil : data[1]
          elem[:HasBeenSeen] = data[2] == nil ? false : data[2]
          elem[:IsAnimated] = data[3] == nil ? false : data[3]
          elem[:MiddleScreenText] = data[4] != ["",""] ? data[4] : ["Middle Screen", "Text"]
          elem[:HoverText] = data[5] != "" ? data[5] : "Hover Text"
          elem[:SelectText] = data[6] != [""] ? data[6] : ["Select Text"]
          elem[:Frames] = data[7] if data[7] != 0
          elem[:FramesToShow] = data[8] if data[8] != [0,0]
          elem[:FrameSkip] = data[9] if data[9] != 0
          elem[:FrameSize] = data[10] if data[10] != [0,0]
          FameChecker.ensureInfoSizeData(famousData[1], elem, data[0])
        end
      end
    end
  }
  return famousData
end
