class Object
  def to_responsys
    self.to_s
  end
end

class String
  def is_responsys_f?
    !!Float(self) rescue false
  end

  def is_responsys_time?
    !!Time.parse(self) rescue false
  end

  def to_responsys_time
    Time.parse(self)
  end

  def is_responsys_bool?
    return false unless self.length == 1
    %w(T F).include?(self)
  end

  def to_responsys_bool
    self == 'T'
  end

  def to_responsys
    return self.to_f if self.is_responsys_f?
    return self.to_responsys_time if self.is_responsys_time?
    return self.to_responsys_bool if self.is_responsys_bool?
    self
  end
end

class Date
  def to_responsys
    self.strftime('%Y-%m-%d %H:%M:%S')
  end
end

class DateTime
  def to_responsys
    self.strftime('%Y-%m-%d %H:%M:%S')
  end
end

class Time
  def to_responsys
    self.strftime('%Y-%m-%d %H:%M:%S')
  end
end

class TrueClass
  def to_responsys
    'T'
  end
end

class FalseClass
  def to_responsys
    'F'
  end
end
