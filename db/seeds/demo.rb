User.destroy_all
User.create(:email => "siatka@opensoftware.pl", :password => "123qweasdzxc", :password_confirmation => "123qweasdzxc")

Settings.destroy_all
Settings.create(:unit_name => "Siatka-DEMO", :email_contact => "contact@opensoftware.pl")

Group.destroy_all
Group.create(:name => "1ANIN1")
Group.create(:name => "1ANIN2")
Group.create(:name => "2ANIN")
Group.create(:name => "3ANIN")

RoomType.destroy_all
room_type1 = RoomType.create(:name => "Wykładowa", :short_name => "W", :description => "Sala wykładowa z rzutnikiem")
room_type2 = RoomType.create(:name => "Laboratorium", :short_name => "Lab", :description => "Sala laboratoryjna niezbędne ochronne obuwie")
room_type3 = RoomType.create(:name => "Zajęcia praktyczne", :short_name => "Ćw", :description => "Sala na zajęcia praktyczne")

Room.destroy_all
Room.create(:name => "02", :room_type_id => room_type1.id)
Room.create(:name => "03", :room_type_id => room_type2.id)
Room.create(:name => "04", :room_type_id => room_type3.id)
