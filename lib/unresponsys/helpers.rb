class Object
  def to_responsys
    self.to_s
  end

  def to_ruby
    self
  end

  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  def present?
    !blank?
  end

  def presence
    self if present?
  end
end

class String
  BLANK_RE = /\A[[:space:]]*\z/

  def is_i?
    return false if self.include?('.')
    return false if self.match(/e|E/)
    !!Integer(self) rescue false
  end

  def is_f?
    return false if self.match(/e|E/)
    self.include?('.') && !!Float(self) rescue false
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

  def blank?
    BLANK_RE === self
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

  def blank?
    false
  end
end

class TrueClass
  def to_responsys
    'T'
  end

  def blank?
    false
  end
end

class FalseClass
  def to_responsys
    'F'
  end

  def blank?
    true
  end
end

class NilClass
  def blank?
    true
  end
end

class Array
  alias_method :blank?, :empty?
end

class Hash
  alias_method :blank?, :empty?
end

class Numeric
  def blank?
    false
  end
end
