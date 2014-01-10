class Lecturer < ActiveRecord::Base
  has_many :blocks

  attr_accessible :full_name, :title

  def name_with_title
    "#{title} #{full_name}"
  end
end
