class Object
  def to_responsys
    self.to_s
  end

  def to_ruby
    self
  end
end

class String
  def is_i?
    return false if self.include?('.')
    !!Integer(self) rescue false
  end

  def is_f?
    !!Float(self) rescue false
  end

  def is_time?
    return false if /[[:alpha:]]/.match(self).present?
    !!Time.parse(self) rescue false
  end

  def to_time
    Time.parse(self)
  end

  def is_bool?
    return false unless self.length == 1
    %w(T F).include?(self)
  end

  def to_bool
    self == 'T'
  end

  def to_ruby
    return self.to_i if self.is_i?
    return self.to_f if self.is_f?
    return self.to_time if self.is_time?
    return self.to_bool if self.is_bool?
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
