class Search
  # redis
  def self.seed
    Medicine.find_each do |medicine|
      name = medicine.name
      1.upto(name.length - 1) do |n|
        prefix = name[0, n]
        $redis.zadd 'search:'+prefix.downcase, 1, name.downcase
      end
    end
  end

  def self.terms_for(prefix)
    $redis.zrevrange 'search:'+prefix.downcase, 0, 9
  end

end