ActiveRecord::Base.transaction do


  pyrite_admin = Role.create!(:name => "Planer", :const_name => :pyrite_admin)

  user = User.new
  user.email = "siatka@opensoftware.pl"
  user.password = "123qweasdzxc"
  user.password_confirmation = "123qweasdzxc"
  user.role = pyrite_admin

  base_unit = AcademyUnit.where(code: 'AT').first

  faculty = Faculty.new(short_name: 'IS', code: 'I', name: 'Informatyka Stosowana', overriding_id: base_unit.id, annual_id: Annual.first.id)
  faculty.save!

  employee = Employee.new(surname: "Adam", name: "Kowalski", room: "13",
                          academy_unit_id: Faculty.first.id,
                          employee_title_id: EmployeeTitle.first.id,
                          language_id: Language.first.id)
  user.verifable = employee
  user.save!
  user.silent_activate!

  academic_year = AcademicYear.first
  Settings.create(:key => "unit_name", :value => "Wydział Informatyki" )
  Settings.create(:key => "email_contact", :value => "contact@opensoftware.pl")
  Settings.create(:key => "event_id_for_editing", :value => academic_year.id)
  Settings.create(:key => "event_id_for_viewing", :value => academic_year.id)
end
