User.destroy_all
User.create(:email => "siatka@opensoftware.pl", :password => "123qweasdzxc", :password_confirmation => "123qweasdzxc")

User.first.has_role "admin"
User.first.has_role "moderator"
User.first.has_role "user"

Settings.create(:unit_name: "Siatka-DEMO", :email_contact => "contact@opensoftware.pl")
