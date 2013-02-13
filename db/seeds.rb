Role.destroy_all
Role.create(:name => "admin")
Role.create(:name => "moderator")
Role.create(:name => "user")

User.destroy_all
User.create(:login => "opensoftware", :email => "contact@opensoftware.pl", :password => "7ygvfr45tgb", :password_confirmation => "7ygvfr45tgb")
User.first.has_role "admin"
User.first.has_role "moderator"
User.first.has_role "user"

