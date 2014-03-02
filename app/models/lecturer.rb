class Lecturer < ActiveRecord::Base
  has_many :blocks, :dependent => :destroy

  attr_accessible :full_name, :title


  validates :full_name, :presence => true

  def name_with_title
    "#{title} #{full_name}"
  end
end
