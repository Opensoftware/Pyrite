Role.destroy_all
Role.create(:name => "admin")
Role.create(:name => "moderator")
Role.create(:name => "user")
