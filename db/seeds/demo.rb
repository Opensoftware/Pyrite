User.destroy_all
User.create(:email => "siatka@opensoftware.pl", :password => "123qweasdzxc", :password_confirmation => "123qweasdzxc")

Settings.create(:unit_name => "Siatka-DEMO", :email_contact => "contact@opensoftware.pl")
