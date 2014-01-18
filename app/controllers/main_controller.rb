# encoding: utf-8
class MainController < ApplicationController
  # TODO wyjaśnić dlaczego poniższe nie działa
  # i trzeba go podawać w każdej metodzie przy renderowaniu
  layout "application"
  include BlocksHelper

  def index
    timetable_forms_data
    render :index, :layout => "application"
  end

  require 'csv'

  def initialize()
     @i = 3
     @j = 0
     @dni1 = %w{pon wto sro czw pia sob nie}
     @dni = %w{pon wto sro czw pia}

     @g1= %w{7:00 8:00 9:00 10:00 11:00 12:00 13:00 14:00 15:00 16:00 17:00 18:00 19:00 20:00}
     @gz= %w{7:00 8:00 9:00 10:00 11:00 12:00 13:00 14:00 15:00 16:00 17:00 18:00 19:00 20:00 21:00}

     @godz1= %w{7:00 7:15 7:30 7:45 8:00 8:15 8:30 8:45 9:00 9:15 9:30 9:45 10:00 10:15 10:30 10:45 11:00 11:15 11:30 11:45 12:00 12:15 12:30 12:45 13:00 13:15 13:30 13:45 14:00 14:15 14:30 14:45 15:00 15:15 15:30 15:45 16:00 16:15 16:30 16:45 17:00 17:15 17:30 17:45 18:00 18:15 18:30 18:45 19:00 19:15 19:30 19:45 20:00 20:15 20:30 20:45}
     @godz= %w{7:00 7:15 7:30 7:45 8:00 8:15 8:30 8:45 9:00 9:15 9:30 9:45 10:00 10:15 10:30 10:45 11:00 11:15 11:30 11:45 12:00 12:15 12:30 12:45 13:00 13:15 13:30 13:45 14:00 14:15 14:30 14:45 15:00 15:15 15:30 15:45 16:00 16:15 16:30 16:45 17:00 17:15 17:30 17:45 18:00 18:15 18:30 18:45 19:00 19:15 19:30 19:45 20:00 20:15 20:30 20:45 21:00}

     @qwe1 = { "7:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"7:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"7:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"7:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"21:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},

     }
     @qwe = { "7:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"7:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"7:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"7:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"8:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"9:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"10:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"11:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"12:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"13:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"14:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"15:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"16:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"17:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"18:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"19:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:15" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:30" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"20:45" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},
	"21:00" => { "pon" => "","wto" => "","sro" => "","czw" => "","pia" => "","sob" => "","nie" => ""},

    }
  end
  def render_404
    render :file => "public/404.html", :status => 404
  end

# Metoda przygotowująca bloki zajęć do wyświetlenia dla danej sali
#
#
  def showroom
	  @blok = 0
		@line = 0
	  @blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0}
    if request.get?
			if !params[:room][:sala].nil?
	      @sala = params[:room][:sala]
	      @mins = Plan.find(:all, :include => :groups, :conditions => {:sala => @sala, :plan_id => getViewPlan})
			end
			@qwe = getblocsroom(@mins)
     else
       @mins = Plan.find(:all)
       respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @mins }
       end
    end
    render :showroom, :layout => "application"
  end

# Metoda przygotowująca bloki zajęć do wyświetlenia dla danej sali bez przeładowywania strony showroom
#
#
  def room
		@line = 0
	  @blok = 0
	  @blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0}
    @dodaj = Plan.new
    if request.post?
      @ustawSala = params[:room][:numer]
      @sale = Plan.find(:all, :conditions => {:sala => params[:room][:numer], :plan_id => getViewPlan})
			@qwe1 = getblocsroom(@sale)
    else
        @sale = Plan.find(:all)
        respond_to do |format|
          format.html # index.html.erb
        end
    end
    render :layout => false
  end

  def showprow
		@line = 0
	  @blok = 0
	  @blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0}
    if request.get?
      @prow = params[:lecturer][:lecture]
      @mins = Plan.find(:all, :conditions => {:prowadzacy => params[:lecturer][:lecture], :plan_id => getViewPlan})
			@qwe = getblocsall(@mins)
    else
      respond_to do |format|
        format.html {render :layout => "application"} # index.html.erb
      end
    end
    render :layout => "application"
  end

  def showgroup
		@line = 0
	  @blok = 0
	  @blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0}
    if request.get?
      @grupa = params[:plan][:id]
      if !@grupa.nil?
        @test = @grupa.split("")
        @tmp = @test[0].to_s + @test[1].to_s
      end
      @kursy = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => @tmp, :plan_id => getViewPlan})

      @mins = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => params[:plan][:id], :plan_id => getViewPlan})

			@qwe = getblocs(@mins)
			@qwe = getblocs(@kursy)
    else
      @mins = Plan.find(:all)
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @mins }
      end
    end
    render :showgroup, :layout => "application"
  end

  def group
		@line = 0
	  @blok = 0
	  @blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0}
    if request.post?
      @grupa = params[:plan][:id]
      if !@grupa.nil?
        @test = @grupa.split("")
        @tmp = @test[0].to_s + @test[1].to_s
      end
      @kursy = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => @tmp, :plan_id => getViewPlan})
      @mins = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => params[:plan][:id], :plan_id => getViewPlan})

			@qwe = getblocs(@mins)
			@qwe = getblocs(@kursy)
    else
      @mins = Plan.find(:all)
      respond_to do |format|
        format.html # index.html.erb
      end
    end
    render :layout => false
  end

  def showkatedra
    @zajecia = []
    if request.post?
      @t = "Zajęcia prowadzone przez katedrę/wydział: #{params[:plan][:katedra]}"
      @mins = Plan.find(:all, :conditions => {:katedra => params[:plan][:katedra], :plan_id => getViewPlan})
    else
      @t = "Zajęcia prowadzone przez wszystkie katedry i wydziały"
      @mins = Plan.find(:all)
    end
    @mins.each { |s| @zajecia.include?(s.przedmiot) ? ("") : (@zajecia << s.przedmiot) }
  end

  def rezerwacje
		@line = 0
		@blok = 0
		@blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0, 'sob' => 0, 'nie' => 0}
    if params[:data].nil?
			@date = Date.parse(Time.now.strftime("%d-%m-%Y")).beginning_of_week
    else
			@date = Date.parse(params[:data]).beginning_of_week
    end
    if params[:room][:sala].nil?
		  @sala = "04"
    else
			@sala = params[:room][:sala]
    end
    @room = Room.new

    if request.get?
      @rezerwacje =  Reservation.where('waznosc BETWEEN ? AND ?', @date.beginning_of_day, @date.end_of_week.end_of_day).where(:sala => @sala )
      for pl in @rezerwacje
        @Gz = (pl.godz.to_i / 60)
        @Mz = pl.godz.to_i - @Gz.minutes
        if (@Mz == 0 )
          @GMz = "#{@Gz}:#{@Mz}0"
        else
          @GMz = "#{@Gz}:#{@Mz}"
        end
				@gr = ""
        @qwe[@GMz][pl.dni] = "#{pl.prowadzacy}::s.#{pl.sala}::#{pl.dlugosc}h::#{pl.przedmiot}::#{pl.rodzaj}::IDR:#{pl.id}"
      end

    end
    render :rezerwacje, :layout => "application"
  end

  def rezer
		@line = 0
		@blok = 0
		@blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0, 'sob' => 0, 'nie' => 0}
    if request.post?
      if params[:data].nil?
				if params[:plan][:wazneod].nil?
				  @date = Date.parse(Time.now.strftime("%d-%m-%Y")).beginning_of_week
				else
					@date = Date.parse(params[:plan][:wazneod])
				end
      else
				@date = Date.parse(params[:data]).beginning_of_week
      end
      if params[:room][:sala].nil?
				if params[:room][:numer].nil?
				  @sala = "31"
				else
				  @sala = params[:room][:numer]
				end
      else
				@sala = params[:room][:sala]
      end
 		  @room = Room.new
			@rezerwacje = Reservation.find(:all, :conditions => { :waznosc => [@date], :sala => @sala })
			@rezerwacje += Reservation.find(:all, :conditions => { :waznosc => [@date+1.days], :sala => @sala })
			@rezerwacje += Reservation.find(:all, :conditions => { :waznosc => [@date+2.days], :sala => @sala })
			@rezerwacje += Reservation.find(:all, :conditions => { :waznosc => [@date+3.days], :sala => @sala })
			@rezerwacje += Reservation.find(:all, :conditions => { :waznosc => [@date+4.days], :sala => @sala })
			@rezerwacje += Reservation.find(:all, :conditions => { :waznosc => [@date+5.days], :sala => @sala })
			@rezerwacje += Reservation.find(:all, :conditions => { :waznosc => [@date+6.days], :sala => @sala })
      for pl in @rezerwacje
        @Gz = (pl.godz.to_i / 60)
        @Mz = pl.godz.to_i - @Gz.minutes
        if (@Mz == 0 )
          @GMz = "#{@Gz}:#{@Mz}0"
        else
          @GMz = "#{@Gz}:#{@Mz}"
        end

        @qwe[@GMz][pl.dni] = "#{pl.prowadzacy}::s.#{pl.sala}::#{pl.dlugosc}h::#{pl.przedmiot}::#{pl.rodzaj}::IDR:#{pl.id}"
      end
     else
       respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @mins }
       end
     end
    render :layout => false
  end

# Eksportowanie planu do postaci sformatowanego pliku CSV
# Zgodny z kalendarzami google, umożliwia przeniesienie planu do kalendarza google
	def exportToCSV
		if !params[:grupa].nil?
			@gr = Group.find(:first, :conditions => {:nazwa => params[:grupa]})

      @tmp = @gr.nazwa.split("")
      @tmp2 = @tmp[0].to_s + @tmp[1].to_s
      @kursy = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => @tmp2, :plan_id => getViewPlan})
      @grupa = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => @gr.nazwa, :plan_id => getViewPlan})
      @grupa += @kursy

		# nagłówek pliku
			plan = StringIO.new
			CSV::Writer.generate(plan,',') do |file|
				file << ['Subject','Start Date','Start Time','End Date','End Time','All Day Event','Description','Location','Private']
				@grupa.each do |g|
					file << [g.przedmiot,'24/05/2009',GetHour(g.godz).to_s,'24/05/2009',GetHour((g.godz.to_i + g.dlugosc.to_i * 45)).to_s,'False','Zajęcia','AGH','True']
				end
			end
			plan.rewind
			send_data(plan.read, :type => 'text/csv;charset=>utf-8;header=present',:filename => 'plan.csv', :disposition => 'attachment', :encoding => 'utf-8')
		end
	end

  def kontakt
    @email = Settings.first.email_contact
    render :kontakt, :layout => "application"
  end

  def howto
    render :howto, :layout => "application"
  end

end
