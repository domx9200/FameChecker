module FameInfoProperty
  def self.set(name, famousPerson)
    return fameInfoEditor(famousPerson)
  end

  def self.format(value)
    return "..."
  end
end

class TwoIntegerProperty
  def initialize(allowNegative = false)
    @allowNegative = allowNegative
  end

  def set(name, oldValue)
    params = ChooseNumberParams.new
    params.setNegativesAllowed(@allowNegative)
    params.setRange(-999, 999) if @allowNegative == true
    params.setRange(0, 999) if @allowNegative == false
    outputs = []
    params.setInitialValue(oldValue[0]) if oldValue and oldValue[0].is_a?(Integer)
    outputs.push(pbMessageChooseNumber(_INTL("Set the value for {1}\[0\].", name), params))
    params.setInitialValue(oldValue[1]) if oldValue and oldValue[1].is_a?(Integer)
    outputs.push(pbMessageChooseNumber(_INTL("Set the value for {1}\[1\].", name), params))
    outputs.each do |i|
      if i == nil
        i = 0
      end
    end
    return outputs
  end

  def defaultValue()
    return "0,0"
  end

  def format(value)
    return value.join(",")
  end
end

module StringArrayProperty
  def self.set(name, oldValue)
    run = true
    outputs = []
    i = 0
    while run
      outputs.push(pbMessageFreeText(_INTL("Set a line, type <end> on an empty line to stop making changes."),
                                    (oldValue and oldValue[i]) ? oldValue[i] : "", false, 250, Graphics.width))
      run = false if outputs.last == "<end>"
      i += 1
    end
    outputs.pop()
    outputs.reject! {|elem| elem == ""}
    return outputs
  end

  def self.format(value)
    return value.join(",")
  end
end

class StringArrayLimitProperty
  def initialize(limit)
    @limit = limit
  end

  def set(name, oldValue)
    outputs = []
    for i in 0...@limit
      outputs.push(pbMessageFreeText(_INTL("Set line {1} of {2}", i, @limit), (oldValue and oldValue[i]) ? oldValue[i] : "",
                                      false, 250, Graphics.width))
    end
    return outputs
  end

  def format(value)
    return value.join(",")
  end
end
