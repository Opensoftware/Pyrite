class MainController < ApplicationController
  include BlocksHelper

  def index
    timetable_forms_data
  end

  def contact
    @email = Settings.email_contact
  end

  def howto
  end

end
