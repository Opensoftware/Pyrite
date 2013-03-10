# encoding: utf-8
# = Schedules_controller.rb - Kontroler planów
#
# Odpowiedzialny za tworzenie nowych planów, edycji i usuwania.
# Podczas usunięcia takiego planu należy pamiętać że zostaną usunięte wszystkie
# wpisy związane z danym planem ( wszystkie plany )
#
# stworzony jako scaffold
#

class SchedulesController < ApplicationController

  # Przeglądanie stworzonych planów (nazw, identyfikatorów)
  def index
    authorize! :manage, Schedule
    @schedules = Schedule.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # Przeglądanie konkretnego wpisu.
  def show
    authorize! :manage, Schedule
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

	# Ekran nowego planu
	#
  def new
    authorize! :manage, Schedule
    @schedule = Schedule.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # Edycja danego planu.
  def edit
    authorize! :manage, Schedule
    @schedule = Schedule.find(params[:id])
  end

  # Tworzenie nowego planu na podstawie otrzymanych parametrów.
  def create
    authorize! :manage, Schedule
    @schedule = Schedule.new(params[:schedule])

    respond_to do |format|
      if @schedule.save
        flash[:notice] = 'Plan zajęć stworzony pomyślnie.'
        format.html { redirect_to(@schedule) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # Zaktualizowanie edytowanego planu.
  def update
    authorize! :manage, Schedule
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        flash[:notice] = 'Plan zaktualizowany pomyślnie.'
        format.html { redirect_to(@schedule) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # Usunięcie danego planu.
  def destroy
    authorize! :manage, Schedule
    @schedule = Schedule.find(params[:id])
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to(schedules_url) }
    end
  end
end
