# TODO I think we do not use roles anymore.
# The idea is to replace cancan by the_role.
Role.destroy_all
Role.create(:name => "admin")
Role.create(:name => "moderator")
Role.create(:name => "user")
