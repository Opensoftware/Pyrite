Studies.class_eval do
  has_many :groups, :class_name => "Pyrite::Group"
end
