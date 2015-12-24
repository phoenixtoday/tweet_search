class Tweet
  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes
    @attributes[:created_at] = @attributes[:created_at].to_datetime
  end

  def to_hash
    @attributes
  end
end