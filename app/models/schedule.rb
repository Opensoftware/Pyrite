class Schedule < ActiveRecord::Base
  has_many :plans, :foreign_key => "plans_id"

   def semestr_rok
      rok + " " + nazwa
   end

end
