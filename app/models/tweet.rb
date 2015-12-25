class Tweet
  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes.symbolize_keys!
    @attributes[:created_at] = @attributes[:created_at].to_datetime
  end

  def reverse_coordinates_for_twitter!
    @attributes[:geo][:coordinates].reverse! if @attributes[:geo] && @attributes[:geo][:coordinates]
  end

  def to_hash
    @attributes
  end
end