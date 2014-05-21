module Pyrite
  class User < ::User

    %w{pyrite_admin}.each do |role|
      define_method "#{role}?" do
        self.role.const_name == role
      end
    end

  end
end
