User.destroy_all
User.create(:email => "siatka@opensoftware.pl", :password => "123qweasdzxc", :password_confirmation => "123qweasdzxc")

Settings.destroy_all
Settings.create(:unit_name => "Siatka-DEMO", :email_contact => "contact@opensoftware.pl")

Group.destroy_all
Group.create(:name => "1ANIN1")
Group.create(:name => "1ANIN2")
Group.create(:name => "2ANIN")
Group.create(:name => "3ANIN")

Room.destroy_all
Room.create(:name => "02")
Room.create(:name => "03")
Room.create(:name => "04")
