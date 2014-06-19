Building.class_eval do
  has_many :rooms, :dependent => :destroy, :class_name => "Pyrite::Room"
end
