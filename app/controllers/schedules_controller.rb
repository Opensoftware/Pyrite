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
  # GET /schedules
  def index
	permit "moderator"
    @schedules = Schedule.find(:all)

    respond_to do |format|
      format.html # index.html.erb
     # format.xml  { render :xml => @schedules }
    end
  end

	# Przeglądanie konkretnego wpisu.
  # GET /schedules/1
  def show
	permit "moderator"
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
  #    format.xml  { render :xml => @schedule }
    end
  end

	# Ekran nowego planu
	#
  # GET /schedules/new
  def new
	permit "moderator"
    @schedule = Schedule.new

    respond_to do |format|
      format.html # new.html.erb
    #  format.xml  { render :xml => @schedule }
    end
  end

	# Edycja danego planu.
  # GET /schedules/1/edit
  def edit
	permit "moderator"
    @schedule = Schedule.find(params[:id])
  end

	# Tworzenie nowego planu na podstawie otrzymanych parametrów.
  # POST /schedules
	#
  def create
	permit "moderator"
    @schedule = Schedule.new(params[:schedule])

    respond_to do |format|
      if @schedule.save
        flash[:notice] = 'Plan zajęć stworzony pomyślnie.'
        format.html { redirect_to(@schedule) }
  #      format.xml  { render :xml => @schedule, :status => :created, :location => @schedule }
      else
        format.html { render :action => "new" }
   #     format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

	# Zaktualizowanie edytowanego planu.
  # PUT /schedules/1
  def update
	permit "moderator"
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        flash[:notice] = 'Plan zaktualizowany pomyślnie.'
        format.html { redirect_to(@schedule) }
  #      format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
   #     format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

	# Usunięcie danego planu.
  # DELETE /schedules/1
  def destroy
	permit "admin"
    @schedule = Schedule.find(params[:id])
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to(schedules_url) }
  #    format.xml  { head :ok }
    end
  end
end
