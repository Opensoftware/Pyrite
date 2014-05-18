module Pyrite
  class MainController < PyriteController
    include Pyrite::BlocksHelper

    skip_before_filter :authenticate_user!, :only => [:index, :contact, :howto]

    def index
      timetable_forms_data
    end

    def contact
      @email = Settings.email_contact
    end

    def howto
    end

  end
end
