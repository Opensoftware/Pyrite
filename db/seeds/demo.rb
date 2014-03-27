User.destroy_all
User.create(:email => "siatka@opensoftware.pl", :password => "123qweasdzxc", :password_confirmation => "123qweasdzxc")

Group.destroy_all
Group.create(:name => "1ANIN1")
Group.create(:name => "1ANIN2")
Group.create(:name => "2ANIN")
Group.create(:name => "3ANIN")

Block::Variant.destroy_all
Block::Variant.create(:name => "Wykład", :short_name => "W", :description =>
                   "Zajęcia audytoryjne", :color => "#93c47d")
Block::Variant.create(:name => "Ćwiczenia", :short_name => "Ćw", :description =>
                   "Zajęcia praktyczne", :color => "#3c78d8")
Block::Variant.create(:name => "Laboratoria", :short_name => "Lab", :description =>
                   "Zajęcia Laboratoryjne", :color => "#dd7e6b")

RoomType.destroy_all
room_type1 = RoomType.create(:name => "Wykładowa", :short_name => "W", :description => "Sala wykładowa z rzutnikiem")
room_type2 = RoomType.create(:name => "Laboratorium", :short_name => "Lab", :description => "Sala laboratoryjna niezbędne ochronne obuwie")
room_type3 = RoomType.create(:name => "Zajęcia praktyczne", :short_name => "Ćw", :description => "Sala na zajęcia praktyczne")

Building.destroy_all
b1 = Building.create(:name => "C1", :address => "Kijowska 4", :latitude => "50.06553", :longitude => "19.922773")
b2 = Building.create(:name => "A0", :address => "Al. Mickiewicza 14", :latitude => "50.064559", :longitude => "19.923277")
b3 = Building.create(:name => "B2", :address => "Czarnowiejska 17", :latitude => "50.066226", :longitude => "19.918921")

Room.destroy_all
b1.rooms.build(:name => "02", :room_type_id => room_type1.id)
b2.rooms.build(:name => "03", :room_type_id => room_type2.id)
b3.rooms.build(:name => "04", :room_type_id => room_type3.id)
b1.save
b2.save
b3.save

AcademicYear.destroy_all
academic_year = AcademicYear.create(:name => "2013/2014", :start_date => "2014-09-01", :end_date => "2015-06-30")
AcademicYear::Event.destroy_all
academic_year.events.build(:name => "Semestr Zimowy", :start_date => "2014-09-01", :end_date => "2015-02-01")
academic_year.events.build(:name => "Semestr Letni", :start_date => "2015-03-01", :end_date => "2015-06-01")
academic_year.events.build(:name => "Sesja zimowa", :start_date => "2015-02-02", :end_date => "2014-06-01", :lecture_free => true)
academic_year.events.build(:name => "Sesja letnia", :start_date => "2015-06-02", :end_date => "2014-06-30", :lecture_free => true)
academic_year.save

Lecturer.destroy_all
Lecturer.create(:title => "prof.", :full_name => "Andrzej Wajda")
Lecturer.create(:title => "dr", :full_name => "Stanisław Kobuszewski")

Settings.destroy_all
Settings.create(:key => "unit_name", :value => "Wydział Informatyki" )
Settings.create(:key => "email_contact", :value => "contact@opensoftware.pl")
Settings.create(:key => "event_id_for_editing", :value => academic_year.id)
Settings.create(:key => "event_id_for_viewing", :value => academic_year.id)
