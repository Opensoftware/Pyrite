module Pyrite
  class MainController < PyriteController
    include Pyrite::BlocksHelper

    skip_authorization_check :only => [:index, :contact, :howto]

    def index
      redirect_to dashboard_index_path if current_user
      timetable_forms_data
    end

    def contact
      @email = Settings.email_contact
    end

    def howto
    end

  end
end
