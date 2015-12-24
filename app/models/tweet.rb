class Tweet
  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes
    @attributes[:created_at] = @attributes[:created_at].to_datetime
    @attributes[:geo][:coordinates].reverse! if @attributes[:geo] && @attributes[:geo][:coordinates]
  end

  def to_hash
    @attributes
  end
end