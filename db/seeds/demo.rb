ActiveRecord::Base.transaction do
  studies = Studies.first
  Pyrite::Group.create(:studies_id => studies.id, :name => "IN1")
  Pyrite::Group.create(:studies_id => studies.id, :name => "IN2")
  Pyrite::Group.create(:studies_id => studies.id, :name => "E1")
  Pyrite::Group.create(:studies_id => studies.id, :name => "E2")

  Pyrite::Block::Variant.destroy_all
  Pyrite::Block::Variant.create(:name => "Wykład", :short_name => "W", :description =>
                     "Zajęcia audytoryjne", :color => "#93c47d")
  Pyrite::Block::Variant.create(:name => "Ćwiczenia", :short_name => "Ćw", :description =>
                     "Zajęcia praktyczne", :color => "#3c78d8")
  Pyrite::Block::Variant.create(:name => "Laboratoria", :short_name => "Lab", :description =>
                     "Zajęcia Laboratoryjne", :color => "#dd7e6b")

  room_type1 = Pyrite::RoomType.create(:name => "Wykładowa", :short_name => "W", :description => "Sala wykładowa z rzutnikiem")
  room_type2 = Pyrite::RoomType.create(:name => "Laboratorium", :short_name => "Lab", :description => "Sala laboratoryjna niezbędne ochronne obuwie")
  room_type3 = Pyrite::RoomType.create(:name => "Zajęcia praktyczne", :short_name => "Ćw", :description => "Sala na zajęcia praktyczne")

  b1 = Building.create(:name => "C1", :address => "Kijowska 4", :latitude => "50.06553", :longitude => "19.922773")
  b2 = Building.create(:name => "A0", :address => "Al. Mickiewicza 14", :latitude => "50.064559", :longitude => "19.923277")
  b3 = Building.create(:name => "B2", :address => "Czarnowiejska 17", :latitude => "50.066226", :longitude => "19.918921")

  b1.rooms.build(:name => "02", :room_type_id => room_type1.id)
  b2.rooms.build(:name => "03", :room_type_id => room_type2.id)
  b3.rooms.build(:name => "04", :room_type_id => room_type3.id)
  b1.save
  b2.save
  b3.save
end
