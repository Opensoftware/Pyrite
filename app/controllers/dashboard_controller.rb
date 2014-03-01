class DashboardController < ApplicationController
  layout "application"
  include BlocksHelper

  def index
    timetable_forms_data
  end

  def prints
    print_forms_data
  end
end
