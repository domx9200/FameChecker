module FameChecker
  class FC
    
    def createTextSprite(lookupName, width, height, z = 0)
      @sprites[lookupName] = Sprite.new(@vp) if !@sprites[lookupName]
      @sprites[lookupName].bitmap.dispose if @sprites[lookupName].bitmap
      @sprites[lookupName].bitmap = Bitmap.new(width, height)
      @sprites[lookupName].z = z
    end

    # Because of the way text is drawn, through the function
    # pbDrawTextPositions, the textArray needs to be specifically filled
    # the order is as follows
    # textToDisplay, Xpos, Ypos, alignment, baseColor, shadowColor, hasOutline
    # width align variables are 0 = right align, 1 = center align, 2 = left align
    # height align variables are 0 = bottom, 1 = center, 2 = top
    def changeText(lookupName, textArray, widthAlign = 0, heightAlign = 0, clrBitMap = true)
      return if !@sprites[lookupName]
      bm = @sprites[lookupName].bitmap
      bm.clear if clrBitMap
      if widthAlign != 0
        textArray.each {|innerArray|
          temp = bm.text_size(innerArray[0]).width
          widthAlign == 1 ? innerArray[1] -= temp / 2 : widthAlign == 2 ? innerArray[1] -= temp : 0
        }
      end

      if heightAlign != 0
        textArray.each { |innerArray|
          temp = bm.text_size(innerArray[0]).height
          heightAlign == 1 ? innerArray[2] -= temp / 2 : heightAlign == 2 ? innerArray[2] -= temp : 0
        }
      end
      pbDrawTextPositions(bm, textArray)
    end

    def changeFont(lookupName, font = nil, fontSize = nil)
      return if !@sprites[lookupName] || (font == nil && fontSize == nil)
      bm = @sprites[lookupName].bitmap
      bm.font.name = font if font != nil
      bm.font.size = fontSize if fontSize != nil
      @sprites[lookupName].bitmap.dispose
      @sprites[lookupName].bitmap = bm
    end

    # text needs to be an array, each line seperated in it's own section
    # example = ["VERIDIAN CITY", "GYM SIGN"]
    # note, if you have more than two, it will skip anything past that
    # pbDrawTextPositions adds 10px of vertical padding, that being said, removing all of the padding will cause
    # the text to display exactly on the top of the infoBox, which isn't ideal, 
    # this padding happens for every line
    def setInfoBoxText(text)
      return if !@sprites["infoBox"]
      return if !@sprites["infoBoxText"]
      x = @baseListX + (@sprites["infoBox"].bitmap.width / 2) #@sprites["infoBox"].bitmap.width / 2 + 18
      y = 4#@textDrawPaddingReset + 4
      textArray = []
      2.times{ |i|
        textArray.push([text[i], x, y, 2, Color.new(0,0,0)])
        y += @sprites["infoBox"].bitmap.text_size(text[i]).height + @textDrawPaddingReset + 7
      }
      changeText("infoBoxText", textArray)
    end

    def drawListText(y = nil)
      return if !@sprites["listText"] || !@sprites["listBox"]
      x = 0 + 18 # @baseListX + 18
      y = 6 + @currentListOffsetY if y == nil #-4 if y == nil # @currentListY
      pos = 0
      textArray = []
      $PokemonGlobal.FameTargets.each{ |i, j|
        if j["seen"]
          textArray.push([i.upcase, x, y, 0, pos != @currentPos ? @baseListTextColor : @selectListTextColor, pos != @currentPos ? @baseListTextShadow : @selectListTextShadow, 0]) 
          @namePosList[pos] = i
          y += @sprites["listText"].bitmap.text_size(i).height + 4 #@textDrawPaddingReset + 14
          pos += 1
        end
      }
      textArray.push(["CANCEL", x, y, 0, pos != @currentPos ? @baseListTextColor : @selectListTextColor, pos != @currentPos ? @baseListTextShadow : @selectListTextShadow, 0])
      @namePosList[@currentPos + 1] = "CANCEL"
      @max = pos
      changeText("listText", textArray)
    end

    def shiftList(up)
      up ? @listPos += 1 : @listPos -= 1
      if @listPos > @max
        @listPos -= 1
        return
      end
      if @listPos <= 0
        @listPos += 1
        return
      end

      @currentListOffsetY -= (@sprites["listText"].bitmap.text_size("t").height + 4) if !up
      @currentListOffsetY += (@sprites["listText"].bitmap.text_size("t").height + 4) if up
      self.drawListText()
    end

    # basically taken from the input section of essentials, modified to work how I need it to
    # credit on this goes to the dev team behind Pokemon Essentials, I honestly don't understand most
    # of what's going on here
    def messageDisplay(msgwindow, message, letterbyletter=true, endOnUse = true, endOnBack = true, commandProc=nil)
      return if !msgwindow
      oldletterbyletter=msgwindow.letterbyletter
      msgwindow.letterbyletter=(letterbyletter) ? true : false
      ret=nil
      commands=nil
      facewindow=nil
      goldwindow=nil
      coinwindow=nil
      battlepointswindow=nil
      cmdvariable=0
      cmdIfCancel=0
      msgwindow.waitcount=0
      autoresume=false
      text=message.clone
      msgback=nil
      linecount=(Graphics.height>400) ? 3 : 2
      ### Text replacement
      text.gsub!(/\\sign\[([^\]]*)\]/i) {   # \sign[something] gets turned into
        next "\\op\\cl\\ts[]\\w["+$1+"]"    # \op\cl\ts[]\w[something]
      }
      text.gsub!(/\\\\/,"\5")
      text.gsub!(/\\1/,"\1")
      if $game_actors
        text.gsub!(/\\n\[([1-8])\]/i) {
          m = $1.to_i
          next $game_actors[m].name
        }
      end
      text.gsub!(/\\pn/i,$Trainer.name) if $Trainer
      text.gsub!(/\\pm/i,_INTL("${1}",$Trainer.money.to_s_formatted)) if $Trainer
      text.gsub!(/\\n/i,"\n")
      text.gsub!(/\\\[([0-9a-f]{8,8})\]/i) { "<c2="+$1+">" }
      text.gsub!(/\\pg/i,"\\b") if $Trainer && $Trainer.male?
      text.gsub!(/\\pg/i,"\\r") if $Trainer && $Trainer.female?
      text.gsub!(/\\pog/i,"\\r") if $Trainer && $Trainer.male?
      text.gsub!(/\\pog/i,"\\b") if $Trainer && $Trainer.female?
      text.gsub!(/\\pg/i,"")
      text.gsub!(/\\pog/i,"")
      text.gsub!(/\\b/i,"<c3=3050C8,D0D0C8>")
      text.gsub!(/\\r/i,"<c3=E00808,D0D0C8>")
      text.gsub!(/\\[Ww]\[([^\]]*)\]/) {
        w = $1.to_s
        if w==""
          msgwindow.windowskin = nil
        else
          msgwindow.setSkin("Graphics/Windowskins/#{w}",false)
        end
        next ""
      }
      isDarkSkin = isDarkWindowskin(msgwindow.windowskin)
      text.gsub!(/\\[Cc]\[([0-9]+)\]/) {
        m = $1.to_i
        next getSkinColor(msgwindow.windowskin,m,isDarkSkin)
      }
      loop do
        last_text = text.clone
        text.gsub!(/\\v\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
        break if text == last_text
      end
      loop do
        last_text = text.clone
        text.gsub!(/\\l\[([0-9]+)\]/i) {
          linecount = [1,$1.to_i].max
          next ""
        }
        break if text == last_text
      end
      colortag = ""
      if $game_system && $game_system.respond_to?("message_frame") &&
         $game_system.message_frame != 0
        colortag = getSkinColor(msgwindow.windowskin,0,true)
      else
        colortag = getSkinColor(msgwindow.windowskin,0,isDarkSkin)
      end
      text = colortag+text
      ### Controls
      textchunks=[]
      controls=[]
      while text[/(?:\\(f|ff|ts|cl|me|se|wt|wtnp|ch)\[([^\]]*)\]|\\(g|cn|pt|wd|wm|op|cl|wu|\.|\||\!|\^))/i]
        textchunks.push($~.pre_match)
        if $~[1]
          controls.push([$~[1].downcase,$~[2],-1])
        else
          controls.push([$~[3].downcase,"",-1])
        end
        text=$~.post_match
      end
      textchunks.push(text)
      for chunk in textchunks
        chunk.gsub!(/\005/,"\\")
      end
      textlen = 0
      for i in 0...controls.length
        control = controls[i][0]
        case control
        when "wt", "wtnp", ".", "|"
          textchunks[i] += "\2"
        when "!"
          textchunks[i] += "\1"
        end
        textlen += toUnformattedText(textchunks[i]).scan(/./m).length
        controls[i][2] = textlen
      end
      text = textchunks.join("")
      signWaitCount = 0
      signWaitTime = Graphics.frame_rate/2
      haveSpecialClose = false
      specialCloseSE = ""
      for i in 0...controls.length
        control = controls[i][0]
        param = controls[i][1]
        case control
        when "op"
          signWaitCount = signWaitTime+1
        when "cl"
          text = text.sub(/\001\z/,"")   # fix: '$' can match end of line as well
          haveSpecialClose = true
          specialCloseSE = param
        when "f"
          facewindow.dispose if facewindow
          facewindow = PictureWindow.new("Graphics/Pictures/#{param}")
        when "ff"
          facewindow.dispose if facewindow
          facewindow = FaceWindowVX.new(param)
        when "ch"
          cmds = param.clone
          cmdvariable = pbCsvPosInt!(cmds)
          cmdIfCancel = pbCsvField!(cmds).to_i
          commands = []
          while cmds.length>0
            commands.push(pbCsvField!(cmds))
          end
        when "wtnp", "^"
          text = text.sub(/\001\z/,"")   # fix: '$' can match end of line as well
        when "se"
          if controls[i][2]==0
            startSE = param
            controls[i] = nil
          end
        end
      end
      ########## Position message window  ##############
      pbRepositionMessageWindow(msgwindow,linecount)
      if facewindow
        pbPositionNearMsgWindow(facewindow,msgwindow,:left)
        facewindow.viewport = msgwindow.viewport
        facewindow.z        = msgwindow.z
      end
      atTop = (msgwindow.y==0)
      ########## Show text #############################
      msgwindow.text = text
      Graphics.frame_reset if Graphics.frame_rate>40
      loop do
        if signWaitCount>0
          signWaitCount -= 1
          if atTop
            msgwindow.y = -msgwindow.height*signWaitCount/signWaitTime
          else
            msgwindow.y = Graphics.height-msgwindow.height*(signWaitTime-signWaitCount)/signWaitTime
          end
        end
        for i in 0...controls.length
          next if !controls[i]
          next if controls[i][2]>msgwindow.position || msgwindow.waitcount!=0
          control = controls[i][0]
          param = controls[i][1]
          case control
          when "f"
            facewindow.dispose if facewindow
            facewindow = PictureWindow.new("Graphics/Pictures/#{param}")
            pbPositionNearMsgWindow(facewindow,msgwindow,:left)
            facewindow.viewport = msgwindow.viewport
            facewindow.z        = msgwindow.z
          when "ff"
            facewindow.dispose if facewindow
            facewindow = FaceWindowVX.new(param)
            pbPositionNearMsgWindow(facewindow,msgwindow,:left)
            facewindow.viewport = msgwindow.viewport
            facewindow.z        = msgwindow.z
          when "g"      # Display gold window
            goldwindow.dispose if goldwindow
            goldwindow = pbDisplayGoldWindow(msgwindow)
          when "cn"     # Display coins window
            coinwindow.dispose if coinwindow
            coinwindow = pbDisplayCoinsWindow(msgwindow,goldwindow)
          when "pt"     # Display battle points window
            battlepointswindow.dispose if battlepointswindow
            battlepointswindow = pbDisplayBattlePointsWindow(msgwindow)
          when "wu"
            msgwindow.y = 0
            atTop = true
            msgback.y = msgwindow.y if msgback
            pbPositionNearMsgWindow(facewindow,msgwindow,:left)
            msgwindow.y = -msgwindow.height*signWaitCount/signWaitTime
          when "wm"
            atTop = false
            msgwindow.y = (Graphics.height-msgwindow.height)/2
            msgback.y = msgwindow.y if msgback
            pbPositionNearMsgWindow(facewindow,msgwindow,:left)
          when "wd"
            atTop = false
            msgwindow.y = Graphics.height-msgwindow.height
            msgback.y = msgwindow.y if msgback
            pbPositionNearMsgWindow(facewindow,msgwindow,:left)
            msgwindow.y = Graphics.height-msgwindow.height*(signWaitTime-signWaitCount)/signWaitTime
          when "ts"     # Change text speed
            msgwindow.textspeed = (param=="") ? -999 : param.to_i
          when "."      # Wait 0.25 seconds
            msgwindow.waitcount += Graphics.frame_rate/4
          when "|"      # Wait 1 second
            msgwindow.waitcount += Graphics.frame_rate
          when "wt"     # Wait X/20 seconds
            param = param.sub(/\A\s+/,"").sub(/\s+\z/,"")
            msgwindow.waitcount += param.to_i*Graphics.frame_rate/20
          when "wtnp"   # Wait X/20 seconds, no pause
            param = param.sub(/\A\s+/,"").sub(/\s+\z/,"")
            msgwindow.waitcount = param.to_i*Graphics.frame_rate/20
            autoresume = true
          when "^"      # Wait, no pause
            autoresume = true
          when "se"     # Play SE
            pbSEPlay(pbStringToAudioFile(param))
          when "me"     # Play ME
            pbMEPlay(pbStringToAudioFile(param))
          end
          controls[i] = nil
        end
        break if !letterbyletter
        Graphics.update
        Input.update
        facewindow.update if facewindow
        if autoresume && msgwindow.waitcount==0
          msgwindow.resume if msgwindow.busy?
          break if !msgwindow.busy?
        end
        if (Input.trigger?(Input::USE) && endOnUse) || (Input.trigger?(Input::BACK) && endOnBack)
          input = Input.trigger?(Input::BACK) ? 0 : 6
          if msgwindow.busy?
            pbPlayDecisionSE if msgwindow.pausing?
            msgwindow.resume
          else
            return input if signWaitCount==0
          end
        end
        pbUpdateSceneMap
        msgwindow.update
        yield if block_given?
        break if (!letterbyletter || commandProc || commands) && !msgwindow.busy?
      end
      Input.update   # Must call Input.update again to avoid extra triggers
      msgwindow.letterbyletter=oldletterbyletter
      if commands
        $game_variables[cmdvariable]=pbShowCommands(msgwindow,commands,cmdIfCancel)
        $game_map.need_refresh = true if $game_map
      end
      if commandProc
        ret=commandProc.call(msgwindow)
      end
      msgback.dispose if msgback
      goldwindow.dispose if goldwindow
      coinwindow.dispose if coinwindow
      battlepointswindow.dispose if battlepointswindow
      facewindow.dispose if facewindow
      if haveSpecialClose
        pbSEPlay(pbStringToAudioFile(specialCloseSE))
        atTop = (msgwindow.y==0)
        for i in 0..signWaitTime
          if atTop
            msgwindow.y = -msgwindow.height*i/signWaitTime
          else
            msgwindow.y = Graphics.height-msgwindow.height*(signWaitTime-i)/signWaitTime
          end
          Graphics.update
          Input.update
          pbUpdateSceneMap
          msgwindow.update
        end
      end
      return ret
    end
  end
end