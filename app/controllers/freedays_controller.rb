# encoding: utf-8
class FreedaysController < ApplicationController
  layout "main"

  # GET /freedays
  # GET /freedays.xml
  def index
    @freedays = Freeday.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @freedays }
    end
  end

  # GET /freedays/new
  # GET /freedays/new.xml
  def new
	permit 'moderator'
    @freeday = Freeday.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @freeday }
    end
  end

  # GET /freedays/1/edit
  def edit
	permit 'moderator'
    @freeday = Freeday.find(params[:id])
  end

  # POST /freedays
  # POST /freedays.xml
  def create
	permit 'moderator'
    @freeday = Freeday.new(params[:freeday])
			@freeday.start = params[:start]
			@freeday.stop = params[:stop]

    respond_to do |format|
      if @freeday.save
        flash[:notice] = 'Wpis dodano prawidłowo.'
        format.html { redirect_to :controler => :freedays }
        format.xml  { render :xml => @freeday, :status => :created, :location => @freeday }
      else
        flash[:notice] = 'Błąd wprowadzania danych'
        format.html { render :action => "new" }
        format.xml  { render :xml => @freeday.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /freedays/1
  # PUT /freedays/1.xml
  def update
	permit 'moderator'
    @freeday = Freeday.find(params[:freeday][:id])
 		@freeday.nazwa = params[:freeday][:nazwa]
	  @freeday.start = params[:start]
		@freeday.stop = params[:stop]
    respond_to do |format|
		if	@freeday.save
        flash[:notice] = 'Freeday was successfully updated.'
        format.html { redirect_to :controller => "freedays" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @freeday.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /freedays/1
  # DELETE /freedays/1.xml
  def destroy
	permit 'moderator'
    @freeday = Freeday.find(params[:id])
    @freeday.destroy

    respond_to do |format|
      format.html { redirect_to(freedays_url) }
      format.xml  { head :ok }
    end
  end
end
