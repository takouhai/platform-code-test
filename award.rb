class Award
  attr_accessor :name, :expires_in, :quality

  def initialize(n, e, q)
    @name = n
    @expires_in = e
    @quality = q
  end

  def update_quality
    case self.name
    # BDP always stays at 80
    when "Blue Distinction Plus"
      self.quality = 80
    # Blue First increases the older it gets
    when "Blue First"
      if has_expired(self.expires_in)
        increase_quality(2)
      else
        increase_quality
      end
    # Blue Compare increases in quality depending on expiration date
    when "Blue Compare"
      if has_expired(self.expires_in)
        self.quality = 0
      else
        if (6..10).cover? self.expires_in
          increase_quality(2)
        elsif (1..5).cover? self.expires_in
          increase_quality(3)
        else
          increase_quality
        end
      end
    # Blue Star loses quality twice as fast as normal awards
    when "Blue Star"
      if has_expired(self.expires_in)
        decrease_quality(4)
      else
        decrease_quality(2)
      end
    # Normal awards decrease once per day, twice if expired
    else
      if has_expired(self.expires_in)
        decrease_quality(2)
      else
        decrease_quality
      end
    end
    # set all to expire except for Blue Distinction Plus
    if self.name != "Blue Distinction Plus"
      self.expires_in -= 1
    end
  end

  # check if value is in range
  def in_range(quality)
    # use cover instead of other methods, it's faster
    # https://github.com/JuanitoFatas/fast-ruby#range
    if (0..50).cover? quality
      true
    else
      false
    end
  end

  # check if expiration date is 0 or less
  def has_expired(expires_in)
    if expires_in <= 0
      true
    else 
      false
    end
  end

  # verbose shorthand for +x and -x
  # keeps values within acceptable ranges
  # no params defaults to +1 and -1
  def increase_quality(amount=1)
    total = self.quality + amount
    if in_range(total)
      self.quality += amount
    elsif total > 50
      self.quality = 50
    elsif total < 0
      self.quality = 0
    end
  end

  def decrease_quality(amount=1)
    total = self.quality - amount
    if in_range(total)
      self.quality -= amount
    elsif total > 50
      self.quality = 50
    elsif total < 0
      self.quality = 0
    end
  end
end