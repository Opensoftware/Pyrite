# encoding: UTF-8
class SiatkaController < ApplicationController
  layout "main"

  # TODO replace by something new
  #auto_complete_for :room, :numer
  #auto_complete_for :lecturer, :lecture
  #auto_complete_for :subject, :nazwa
  #in_place_edit_for :plan, :dni

  before_filter :authenticate_user!

  def render_404
    render :file => "public/404.html", :status => 404
  end

 def admin
   if request.post?
     @us = User.find(:all)
     for i in @us
#konto admina
        if params[i.login.to_s]['admin'] == 'tak'
	  if !(i.has_role? 'admin')
            i.has_role 'admin'
   	  end
        else
          i.has_no_role 'admin'
        end
#konto wprowadzacza :)
        if params[i.login.to_s]['moderator'] == 'tak'
	  if !(i.has_role? 'moderator')
            i.has_role 'moderator'
   	  end
        else
          i.has_no_role 'moderator'
        end
#konto kierownika katedry
        if params[i.login.to_s]['kierownik'] == 'tak'
	  if !(i.has_role? 'kierownik')
            i.has_role 'kierownik'
   	  end
        else
          i.has_no_role 'kierownik'
        end
#konto użytkownika
        if params[i.login.to_s]['user'] == 'tak'
          if !(i.has_role? 'user')
            i.has_role 'user'
          end
        else
          i.has_no_role 'user'
        end
     end
   else
    @us = User.find(:all)
   end
 end

 def pozycjagodz(a)
    @i = (a.to_i - 420)
   if @i == 0
     @k = 35
   else
      @i = @i / 15
      @k = (@i * 4) + 35
   end
   @k
  end

  def pozycjadnia(a)
     case a
     when "pon"
          @i=30
     when "wto"
          @i=65
     when "sro"
          @i=100
     when "czw"
          @i=135
     when "pia"
          @i=170
     else
         @i=""
     end
    @i
  end

  def edit
    @sale = Room.find(:all)
    @salee = []
    for pl in @sale
      @salee << pl.numer
    end
    @salee = @salee.sort { |a,b| a.to_i <=> b.to_i}
    @tmp = params[:id].to_s.split(":")
    if @tmp[0] == "IDR"
      @dodaj = Reservation.find(@tmp[1])
    else
      @dodaj = Plan.find_by_id(@tmp[1])
      @grupy = Array.new
      for i in @dodaj.groups
        @grupy << i.nazwa
      end
    end
    render :layout => "application"
  end


  def sala

  end

  def preview
    @room_number = params[:room][:numer]
    @groups = params[:dodaj][:grupa].reject(&:empty?) if params[:dodaj] and params[:dodaj][:grupa]
    @dodaj = Plan.new
    @plany = Array.new
    @kursy = Array.new
    @ustawGrupe = params[:g]
    @ustawSala = params[:dodaj][:sala]
    @sale = Plan.find(:all, :conditions => {:sala => params[:room][:numer], :plan_id => getEditPlan})
    if !params[:dodaj][:grupa].nil?
      for i in params[:dodaj][:grupa]
        @test = i.split("")
        @kursy += Plan.find(:all, :include => :groups, :conditions => {'groups.nazwa' => "#{@test[0]}#{@test[1]}", :plan_id => getEditPlan})
        @plany += Plan.find(:all, :include => :groups, :conditions => {'groups.nazwa' => i, :plan_id => getEditPlan})
      end
    end
    @Gz = params[:dodaj][:godz].to_i
    @kom = (params[:dodaj][:dlugosc].to_f * 3).to_i
    @spr = Array.new(@kom)
    @kom.times { |i| @spr[i] = @Gz + ( i * 15 )}

    @qwe = getblocs(@kursy)
    @qwe = getblocs(@plany)
    @qwe1 = getblocsroom(@sale)
    render :partial => "schedules_table", :layout => false
  end

  def index
    render :index, :layout => "application"
  end

  def uzup
   @sal = Room.find(:all)
   render :layout => false
  end

  def addr
  end

  def add
    @room_number = params[:sala]
    @groups = params[:grupa].reject(&:empty?) if params[:grupa]
    @dodaj = Plan.new
    @sale = Room.find(:all)
    @salee = []
    for pl in @sale
      @salee << pl.numer
    end
    @salee = @salee.sort { |a,b| a.to_i <=> b.to_i}
    if request.get?
      if !params[:grupa].nil?
        for i in params[:grupa]
          @test = i.split("")
          @ustawGrupe = i
          @tmp = @test[0].to_s + @test[1].to_s
        end
        @kursy = Plan.find(:all, :include => :groups, :conditions => {'groups.nazwa' => "#{@tmp}", :plan_id => getEditPlan})
        @plany = Plan.find(:all, :include => :groups, :conditions => {'groups.nazwa' => @ustawGrupe, :plan_id => getEditPlan })
        @sl = Plan.find(:all, :conditions => {:sala =>params[:sala], :plan_id => getEditPlan})
        @qwe = getblocs(@kursy)
        @qwe = getblocs(@plany)
        @qwe1 = getblocsroom(@sl)
      end
    end
    render :layout => "application"
  end

  def del
    if params[:re] == "r"
      @main = Reservation.find_by_id(params[:id])
      if @main.nil?
        flash[:notice] = "Błędny ID"
        redirect_to :action => "add"
      else
        @main.destroy
        flash[:notice] = "Rezerwacja została usunięta"
        redirect_to :action => "rezerwacja", :params => {:grupa => { "" => @main.grupa} }

      end
    else
      @main = Plan.find_by_id(params[:id])
      if @main.nil?
        flash[:error] = "Błędny ID"
        redirect_to :action => "add"
      else
        flash[:notice] = "Wpis został usunięty"
        @main.destroy
        redirect_to :action => "add", :params => {:grupa => {"" => @main.grupa}, :katedra => @main.katedra, :sala => @main.sala }
      end
    end
  end

  def adding
    if params[:room][:numer].empty?
      flash[:error] = "Niekompletny wpis: brakuje pola Sala"
      redirect_to :action => "add", :params => {:godz => params[:dodaj][:godz], :katedra => params[:dodaj][:katedra], :dni => params[:dodaj][:dni], :grupa => params[:dodaj][:grupa], :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture], :czestotliwosc => params[:dodaj][:czestotliwosc],:przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi] }

    elsif
      if params[:dodaj][:grupa].nil?
        flash[:error] = "Niekompletny wpis: brakuje pola Grupa"
        redirect_to :action => "add", :params => {:godz => params[:dodaj][:godz], :katedra => params[:dodaj][:katedra], :dni => params[:dodaj][:dni], :grupa => "", :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture], :czestotliwosc => params[:dodaj][:czestotliwosc],:przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi] }

      end

    else

      if params[:date].nil?
        @date = "1-09-2008"
      else
        @date = params[:date]
      end
      @kom1 = params[:dodaj][:dlugosc].to_i * 3
      @Gz = params[:dodaj][:godz].to_i
      #  @kom = @dodaj4.to_f * 3
      #  @kom1 = @kom.to_i
      @jest = 0
      @przedmiot = Subject.find(:first, :conditions => { :nazwa => params[:subject][:nazwa] })
      if @przedmiot.nil?
        @przed = Subject.new
        @przed.nazwa = params[:subject][:nazwa]
        @przed.katedra = params[:dodaj][:katedra]
        @przed.save
      end
      @prowadzacy = Lecturer.find(:first, :conditions => { :lecture => params[:lecturer][:lecture] })

      if @prowadzacy.nil?
        @prowadzacy = Lecturer.new
        @prowadzacy.lecture = params[:lecturer][:lecture]
        @prowadzacy.save
      end

      # stworzenie tablicy z godzinami dla wprowadzanych zajęć
      @spr = Array.new(@kom1)
      @kom1.times { |i| @spr[i] = @Gz + ( i * 15 )}
      if ( @spr[@kom.to_i - 1] > 1275)
        @jest = 5
      else
        # sprawdzanie dostępności sali
        if params[:room][:numer].to_s != "WF" && params[:room][:numer].to_s != "SJO"
          @sp = Plan.find(:all, :conditions =>  ["id != '#{params[:dodaj][:id].to_i}' AND sala = '#{params[:room][:numer]}' AND dni = '#{ params[:dodaj][:dni]}' AND plan_id = '#{getEditPlan}'"])
          # mtfk
          # tymczasowy fix na kolizje zajec ze starym semestrem
          #  @sp2 = Reservation.find(:all, :conditions => "sala = '#{params[:room][:numer]}' AND dni ='#{params[:dodaj][:dni]}' AND id != '#{params[:dodaj][:id].to_i}' AND waznosc >= '#{Date.parse(Time.now.strftime('%d-%m-%Y'))}'")
          @sp2 = Reservation.find(:all, :conditions => "sala = '#{params[:room][:numer]}' AND dni ='#{params[:dodaj][:dni]}' AND id != '#{params[:dodaj][:id].to_i}' AND waznosc >= '#{Date.parse('25-02-2013')}'")
          for s in @sp2
            if checkfreetime(s.waznosc.strftime('%d-%m-%Y'))
              @dod = s.dlugosc.to_i * 3
              @godz1 = s.godz.to_i
              @kom2 = @dod.to_i
              @spr1 = Array.new(@kom2)
              @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }
              @kom2.times { |j| @kom1.times { |i|
                if (@spr[i] == @spr1[j] )
                  @jest = 1
                end }}
            end
          end
          for s in @sp
            @dod = s.dlugosc.to_i * 3
            @godz1 = s.godz.to_i
            @kom2 = @dod.to_i
            @spr1 = Array.new(@kom2)
            @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }
            @kom2.times { |j| @kom1.times { |i|
              if (@spr[i] == @spr1[j] )
                @jest = 1
              end }}
          end
        end
        if @jest != 1
          #sprawdzanie wykładowcy
          @sp = Plan.find(:all, :conditions => ["id != '#{params[:dodaj][:id].to_i}' AND prowadzacy LIKE '#{params[:lecturer][:lecture]}' AND plan_id = '#{getEditPlan}' AND dni LIKE '#{params[:dodaj][:dni]}'"])
          for s in @sp
            @dod = s.dlugosc.to_i * 3
            @godz1 = s.godz.to_i
            @kom2 = @dod.to_i
            @spr1 = Array.new(@kom2)
            @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }
            @kom2.times { |j| @kom1.times { |i|
              if (@spr[i] == @spr1[j] )
                @jest = 2
              end }}
          end

          if @jest != 2

            # sprawdzanie dostępności kursu
            #
            for i in params[:dodaj][:grupa]

              if checkfreetime(@date)
                @test = i.split("")
                @tmp = @test[0].to_s + @test[1].to_s
                if !params[:dodaj][:id].nil?
                  @kursy = Plan.find(:all, :include => :groups, :conditions => [" plans.plan_id = ? AND groups.nazwa = ? AND dni = ? AND plans.id <> ?",getEditPlan, @tmp,params[:dodaj][:dni],params[:dodaj][:id]] )
                else
                  @kursy = Plan.find(:all, :include => :groups, :conditions => [" plans.plan_id = ? AND groups.nazwa = ? AND dni = ?",getEditPlan, @tmp,params[:dodaj][:dni]] )
                end
              else
                @kursy = "";
              end
              for s in @kursy
                @dod = s.dlugosc * 3
                @godz1 = s.godz.to_i
                @kom = @dod.to_i
                @kom2 = @kom.to_i
                @spr1 = Array.new(@kom2)
                @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

                @kom2.times { |j| @kom1.times { |i|
                  if  (j != 0) && ( j != (@kom2-1 ))
                    if (@spr[i] == @spr1[j] )
                      @jest = 4
                    end
                  end }}
              end
            end
          end
          if @jest != 4
            # sprawdzanie zajętości grupy
            #
            for i in params[:dodaj][:grupa]

              if checkfreetime(@date)
                if (i == "inne")
                  @sp1 = ""
                else
                  if !params[:dodaj][:id].nil?
                    @sp1 = Plan.find(:all, :include => :groups, :conditions => [" plans.plan_id = ? AND dni = ?  AND groups.nazwa = ? AND plans.id <> ?", getEditPlan,params[:dodaj][:dni],i, params[:dodaj][:id] ] )
                  else
                    @sp1 = Plan.find(:all, :include => :groups, :conditions => ["  plans.plan_id = ? AND dni = ?  AND groups.nazwa = ?",getEditPlan,params[:dodaj][:dni],i ] )
                  end
                end

                for s in @sp1
                  @dod = s.dlugosc * 3
                  @godz1 = s.godz.to_i
                  @kom = @dod.to_i  #to_f / 0.25
                  @kom2 = @kom.to_i
                  @spr1 = Array.new(@kom2)
                  @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

                  @kom2.times { |j| @kom1.times { |i|
                    #      	   if  (j != 0) && ( j != (@kom2-1 ))
                    if (@spr[i] == @spr1[j] )
                      @jest = 3
                      #	           end
                    end }}
                end

              end
            end # end if @jest != 4
          end # end if @jest != 2
        end # end if @jest != 1
      end # end if @jest = 5
      case @jest
      when 1
        flash[:error] = "Sala jest w tym czasie zajęta, sprawdź rozkład i rezerwacje"
      when 2
        flash[:error] = "Wykładowca w tym czasie prowadzi już zajęcia"
      when 3
        flash[:error] = "Grupa ma w tym czasie już zajęcia"
      when 4
        flash[:error] = "Kurs ma w tym czasie zajęcia"
      when 5
        flash[:error] = "Przekroczono maksymalną długość zajęć"
      else
        flash[:notice] = "Wpis dodany prawidłowo"
        # podczas edycji edytowany wpis jest kasowany i tworzony na nowo
        if !params[:dodaj][:id].nil?
          @del = Plan.find_by_id(params[:dodaj][:id])
          @del.destroy
        end
        @planid = Settings.find(:first)
        @pp = Plan.create(:plan_id => @planid.plan_to_edit , :godz => params[:dodaj][:godz], :katedra => params[:dodaj][:katedra], :dni => params[:dodaj][:dni], :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture], :czestotliwosc => params[:dodaj][:czestotliwosc],:przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi])
        for i in params[:dodaj][:grupa]
          @g = Group.find(:first, :conditions => {:nazwa => i})
          @g.plans << @pp if @g
        end
      end
      redirect_to :action => "add", :params => {:godz => params[:dodaj][:godz], :katedra => params[:dodaj][:katedra], :dni => params[:dodaj][:dni], :grupa => params[:dodaj][:grupa], :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture], :czestotliwosc => params[:dodaj][:czestotliwosc],:przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi] }
    end
  end

 def rezerwacja
   @dodaj = Reservation.new
   @sale = Room.find(:all)
   @salee = []
   for pl in @sale
     @salee << pl.numer
   end
   @salee = @salee.sort { |a,b| a.to_i <=> b.to_i}
   render :rezerwacja, :layout => "application"
 end

 def rrezerwacja
   @dodaj = Reservation.new
   render :layout => "application"
 end

 def addrez
   if params[:dodaj][:sala].empty?
     flash[:error] = "Niekompletny wpis: brakuje pola Sala"
     #     redirect_to :action => "rezerwacja", :params => {:godz => params[:dodaj][:godz], :grupa => params[:dodaj][:grupa], :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture], :przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi] }
     redirect_to :action => "rezerwacja", :params => params[:dodaj]
   elsif params[:dodaj][:waznosc].empty?
     flash[:error] = "Niekompletny wpis: brakuje pola termin rezerwacji"
     #       redirect_to :action => "rezerwacja", :params => {:godz => params[:dodaj][:godz], :grupa => params[:dodaj][:grupa], :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture], :czestotliwosc => params[:dodaj][:czestotliwosc],:przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi] }
     redirect_to :action => "rezerwacja", :params => params[:dodaj]
   elsif  params[:dodaj][:prowadzacy].empty?
     flash[:error] = "Niekompletny wpis: brakuje pola prowadzący"
     redirect_to :action => "rezerwacja", :params => params[:dodaj]
   else
     @date = params[:dodaj][:waznosc]
     @dzien = getpolishname(Date.parse(params[:dodaj][:waznosc]).strftime("%a"))

     @kom1 = params[:dodaj][:dlugosc].to_i * 3
     @Gz = params[:dodaj][:godz].to_i
     @jest = 0
     @przedmiot = Subject.find(:first, :conditions => { :nazwa => params[:dodaj][:sala] })
     if @przedmiot.nil?
       @przed = Subject.new
       @przed.nazwa = params[:dodaj][:sala]
       @przed.save
     end
     @prowadzacy = Lecturer.find(:first, :conditions => { :lecture => params[:dodaj][:prowadzacy] })

     if @prowadzacy.nil?
       @prowadzacy = Lecturer.new
       @prowadzacy.lecture = params[:dodaj][:prowadzacy]
       @prowadzacy.save
     end

     # stworzenie tablicy z godzinami dla wprowadzanych zajęć
     @spr = Array.new(@kom1)
     @kom1.times { |i| @spr[i] = @Gz + ( i * 15 )}
     if ( @spr[@kom.to_i - 1] > 1275)
       @jest = 5
     else
       # sprawdzanie dostępności sali
       #
       if params[:dodaj][:sala].to_s != "U2"
         if checkfreetime(@date)
           if (Date.parse("2010-01-01 00:00").strftime("%Y-%m-%d %H:%M %p")) <= Date.parse(@date).strftime("%Y-%m-%d %H:%M %p") && Date.parse(@date).strftime("%Y-%m-%d %H:%M %p") <= Date.parse("2010-02-28 23:00").strftime("%Y-%m-%d %H:%M %p")
             puts  "stary plan"
             @sp = Plan.find(:all, :conditions => {:sala => params[:dodaj][:sala], :dni => @dzien, :plan_id => getViewPlan})
           else
             puts  "nowy plan"
             @sp = Plan.find(:all, :conditions => {:sala => params[:dodaj][:sala], :dni => @dzien, :plan_id => getEditPlan})
           end
         else
           @sp = []
         end
         @sp2 = Reservation.find(:all, :conditions => {:sala => params[:dodaj][:sala],  :waznosc => Date.parse(params[:dodaj][:waznosc])})
         for s in @sp2
           @dod = s.dlugosc.to_i * 3
           @godz1 = s.godz.to_i
           @kom2 = @dod.to_i
           @spr1 = Array.new(@kom2)
           @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }
           @kom2.times { |j| @kom1.times { |i|
             if (@spr[i] == @spr1[j] )
               @jest = 1
             end }}
         end
         for s in @sp
           @dod = s.dlugosc.to_i * 3
           @godz1 = s.godz.to_i
           @kom2 = @dod.to_i
           @spr1 = Array.new(@kom2)
           @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }
           @kom2.times { |j| @kom1.times { |i|
             if (@spr[i] == @spr1[j] )
               @jest = 1
             end }}
         end
       end
       if @jest != 1
         #sprawdzanie wykładowcy
         @sp = Plan.find(:all, :conditions => {:prowadzacy => params[:dodaj][:prowadzacy], :dni => @dzien, :plan_id => getEditPlan})
         @sp += Reservation.find(:all, :conditions => {:prowadzacy => params[:dodaj][:prowadzacy],  :waznosc => Date.parse(params[:dodaj][:waznosc])})
         for s in @sp
           @dod = s.dlugosc.to_i * 3
           @godz1 = s.godz.to_i
           @kom2 = @dod.to_i
           @spr1 = Array.new(@kom2)
           @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

           @kom2.times { |j| @kom1.times { |i|
             if (@spr[i] == @spr1[j] )
               @jest = 2
             end }}
         end

         if @jest != 2
           #
           # sprawdzanie dostępności kursu
           #

           if checkfreetime(@date)
             @test = params[:dodaj][:grupa].split("")
             @tmp = @test[0].to_s + @test[1].to_s
             @kursy = Plan.find(:all, :conditions => {:plan_id => getEditPlan, :grupa => @tmp, :dni => @dzien})
             @kursy2 = Reservation.find_by_sql("SELECT * from reservations WHERE grupa LIKE '#{@tmp}' AND  waznosc = '#{Date.parse(params[:dodaj][:waznosc])}'")
             for s in @kursy2
               @dod = s.dlugosc * 3
               @godz1 = s.godz.to_i
               @kom = @dod.to_i  #f / 0.25 można wywalić i zastąpic
               @kom2 = @kom.to_i
               @spr1 = Array.new(@kom2)
               @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

               @kom2.times { |j| @kom1.times { |i|
                 if  (j != 0) && ( j != (@kom2-1 ))
                   if (@spr[i] == @spr1[j] )
                     @jest = 4
                   end
                 end }}
             end

             for s in @kursy
               @dod = s.dlugosc * 3
               @godz1 = s.godz.to_i
               @kom = @dod.to_i  #f / 0.25 można wywalić i zastąpic
               @kom2 = @kom.to_i
               @spr1 = Array.new(@kom2)
               @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

               @kom2.times { |j| @kom1.times { |i|
                 if  (j != 0) && ( j != (@kom2-1 ))
                   if (@spr[i] == @spr1[j] )
                     @jest = 4
                   end
                 end }}

             end
           end
           if @jest != 4

             # sprawdzanie zajętości grupy


             if (params[:dodaj][:grupa] == "inne")
               @sp1 = ""
             else
               if checkfreetime(@date)
                 @sp1 = Plan.find(:all, :conditions => {:grupa => params[:dodaj][:grupa], :dni => @dzien, :plan_id => getEditPlan})
               else
                 @sp1 = []
               end
               @sp2 = Reservation.find(:all, :conditions => {:grupa => params[:dodaj][:grupa],  :waznosc => Date.parse(params[:dodaj][:waznosc])})
               for s in @sp2
                 @dod = s.dlugosc * 3
                 @godz1 = s.godz.to_i
                 @kom = @dod.to_i  #to_f / 0.25
                 @kom2 = @kom.to_i
                 @spr1 = Array.new(@kom2)
                 @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

                 @kom2.times { |j| @kom1.times { |i|
                   if  (j != 0) && ( j != (@kom2-1 ))
                     if (@spr[i] == @spr1[j] )
                       @jest = 3
                     end
                   end }}
               end
               for s in @sp1
                 @dod = s.dlugosc * 3
                 @godz1 = s.godz.to_i
                 @kom = @dod.to_i
                 @kom2 = @kom.to_i
                 @spr1 = Array.new(@kom2)
                 @kom2.times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

                 @kom2.times { |j| @kom1.times { |i|
                   if  (j != 0) && ( j != (@kom2-1 ))
                     if (@spr[i] == @spr1[j] )
                       @jest = 3
                     end
                   end }}
               end
             end
             # sprawdzanie czy sala jest zajeta z poprzedniego warunku i pętli (zmienna @jest jeżeli @jest =1 sala zajeta
           end # end if @jest != 4
         end # end if @jest != 2
       end # end if @jest != 1
     end # end if @jest = 5
     case @jest
     when 1
       flash[:error] = "Sala jest w tym czasie zajęta"
     when 2
       flash[:error] = "Wykładowca w tym czasie prowadzi już zajęcia"
     when 3
       flash[:error] = "Grupa ma w tym czasie już zajęcia"
     when 4
       flash[:error] = "Kurs lub Grupa ma w tym czasie zajęcia"
     when 5
       flash[:error] = "Przekroczono maksymalną długość zajęć"
     else
       flash[:notice] = "Rezerwacja dodano prawidłowo"
       params[:dodaj][:dni] = @dzien
       @dodaj = Reservation.create(params[:dodaj])
       @add = Array.new(@kom1)
     end
     redirect_to :action => "rezerwacja", :params => {:godz => params[:dodaj][:godz], :grupa => params[:dodaj][:grupa], :dlugosc => params[:dodaj][:dlugosc], :rodzaj => params[:dodaj][:rodzaj], :uwagi => params[:dodaj][:uwagi] }
   end

 end

#sprawdzanie dostepnosci sal dla rezerwacji
 def formularz
   if params[:date].first.empty?
     @date = "1-01-2009"
   else
     @date = params[:date].first
     @dzien = getpolishname(Date.parse(@date).strftime("%a"))
   end
   if Date.parse(@date) >= Date.parse("30-06-2013")
     @free = ""
   else
     @zm = "si"
     @Gz = params[:dodaj][:godz].to_i
     @GzEnd = @Gz + (params[:dodaj][:dlugosc].to_i * 45)
     @zajete = []
     if checkfreetime(@date)
       if (Date.parse("2010-01-01 00:00").strftime("%Y-%m-%d %H:%M %p")) <= Date.parse(@date).strftime("%Y-%m-%d %H:%M %p") && Date.parse(@date).strftime("%Y-%m-%d %H:%M %p") <= Date.parse("2010-02-28 23:00").strftime("%Y-%m-%d %H:%M %p")
         @sp = Plan.find(:all, :conditions => {:dni => @dzien, :plan_id => getViewPlan})
       else
         @sp = Plan.find(:all, :conditions => {:dni => @dzien, :plan_id => getEditPlan})
       end
     else
       @sp = []
     end
     @sp2 = Reservation.find(:all, :conditions => { :waznosc => @date})
     for s in @sp
       @godz = s.godz.to_i
       @godzEnd = s.godz.to_i + (s.dlugosc.to_i * 45)
       if ((@Gz.to_i > s.godz.to_i) && (@Gz.to_i < @godzEnd)) || (( @GzEnd.to_i < @godzEnd) && (@GzEnd.to_i  > @godz)) || (@Gz.to_i < @godz && @GzEnd > @godzEnd) || (@Gz.to_i < @godz && (@GzEnd == @godzEnd)) || (@Gz.to_i == @godz && @GzEnd == @godzEnd) || (@Gz == @godz && @GzEnd > @godzEnd)
         @zajete << s.sala
       end
     end

     for s in @sp2
       @godz = s.godz.to_i
       @godzEnd = s.godz.to_i + (s.dlugosc.to_i * 45)
       if ((@Gz.to_i > s.godz.to_i) && (@Gz.to_i < @godzEnd)) || (( @GzEnd.to_i < @godzEnd) && (@GzEnd.to_i  > @godz)) || (@Gz.to_i < @godz && @GzEnd > @godzEnd) || (@Gz.to_i < @godz && (@GzEnd == @godzEnd)) || (@Gz.to_i == @godz && @GzEnd == @godzEnd) || (@Gz == @godz && @GzEnd > @godzEnd)
         @zajete << s.sala
       end
     end
     @usun = []
     @usun[0] = "U2"
     @usun[1] = "213"
     if !checkfreetime(@date)
       @sale2 = []
       @sale = Room.find(:all)
       for i in @sale
         @sale2 << i.numer
       end
       @free = @sale2 - @zajete.uniq - @usun
       @free = @free.sort { |a,b| a.to_i <=> b.to_i}
     else
       # TODO wykluczenie poszczególnych dni z rezerwacji ( w tym wypadku sobota i niedziela)
       if @dzien #!= 'sob' && @dzien != 'nie'
         @sale2 = []
         @sale = Room.find(:all)
         for i in @sale
           @sale2 << i.numer
         end
         @free = @sale2 - @zajete.uniq - @usun
         @free = @free.sort { |a,b| a.to_i <=> b.to_i}
       else
         @free =""
       end
     end
   end
   render :layout => false
 end

  def pomoc(plany)
    @kolizje = Array.new
    for s in @plany
      @spr = Array.new
      (s.dlugosc.to_i * 3).times { |i| @spr[i] = s.godz.to_i + ( i * 15 )}
      for k in @plany
        @check = 0
        if k != s
          @godz1 = k.godz.to_i
          @kom2 = k.dlugosc.to_i * 3
          @spr1 = Array.new
          (@kom2).times { |i| @spr1[i] = @godz1 + ( i * 15 ) }

          (@kom2).times { |j| (s.dlugosc.to_i * 3).times { |i|
            if  (j != 0) && ( j != (@kom2 ))
              if (@spr[i] == @spr1[j] )
                @check = 1
              end
            end }}
            if @check == 1
              @kolizje << k
            end
        end
      end
    end
    return @kolizje
  end

 def  kolizje
   @dni = %w{pon wto sro czw pia sob nie}
   @wynik = Array.new
   @sale = Room.find(:all)
   for i in @dni
      for sala in @sale
        @plany = Plan.find(:all, :conditions => {:dni => i, :sala => sala.numer, :plan_id => getEditPlan })
        @wynik += pomoc(@plany)
      end
   end
 end

 def  kolizjegrup
   @dni = %w{pon wto sro czw pia sob nie}
   @wynik = Array.new
   @grupy = Group.find(:all)
   for i in @dni
     for grupa in @grupy
       if grupa.nazwa != "inne"
         @plany = Plan.find(:all, :include => 'groups', :conditions => [" plans.plan_id = ? AND dni = ? AND (groups.nazwa = ? OR groups.nazwa = ?)",getEditPlan,i,grupa.nazwa,"#{grupa.rok}#{grupa.kurs}"] )
         @wynik += pomoc(@plany)
       end
     end
   end
 end

 def drukowanie
 end

 #generowanie obciążeń sal i inne statystyki
 def statystyki
   @salewykladowe = Room.find(:all, :conditions => { :rodzaj => "W" })
   @bloki = {'pon' => { '31' => Array.new, '133' => Array.new, '115' => Array.new, "221" => Array.new, "380" => Array.new},
     'wto' => { '31' => Array.new, '133' => Array.new, '115' => Array.new, "221" => Array.new, "380" => Array.new},
     'sro' => { '31' => Array.new, '133' => Array.new, '115' => Array.new, "221" => Array.new, "380" => Array.new},
     'czw' => { '31' => Array.new, '133' => Array.new, '115' => Array.new, "221" => Array.new, "380" => Array.new},
     'pia' => { '31' => Array.new, '133' => Array.new, '115' => Array.new, "221" => Array.new, "380" => Array.new},
   }
   @dd = %w{pon wto sro czw pia}
   for i in @dd
     for d in @salewykladowe
       @bloki[i][d.numer.to_s] = Plan.find(:all,:conditions => { :sala => d.numer, :dni => i, :plan_id => getViewPlan })
     end
   end

 end

 def zestawienie
   @kierunki = Hash.new

   if !params[:grupa].nil? and !params[:grupa][:nazwa].nil?
     @grupy = Group.find(:all, :conditions => {:nazwa => params[:grupa][:nazwa]})
     @grupy = Group.find(:all, :conditions => {:rok => @grupy.first.rok, :kierunek => @grupy.first.kierunek})
   else
     @grupy = Group.find(:all)
   end
   @getViewPlan = getViewPlan

   @grupy.each do |g|
     if g.nazwa[1] == 73
       name = "#{g.nazwa}"
     else
       name = "#{g.rok}#{g.kierunek}"
     end
     @kierunki[name] ||= {:zajecia => [], :empty => false}
     tmp = g.nazwa.split("")
     tmp2 = tmp[0].to_s + tmp[1].to_s
     kursy_czw = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => tmp2, :dni => "czw", :plan_id => @getViewPlan})
     kursy_pia = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => tmp2, :dni => "pia", :plan_id => @getViewPlan})
     grupa_czw = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => g.nazwa, :dni => "czw", :plan_id => @getViewPlan})
     grupa_pia = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => g.nazwa, :dni => "pia", :plan_id => @getViewPlan})
     grupa_czw += kursy_czw
     grupa_pia += kursy_pia
     #@kierunki[name][:empty] = true  if grupa_czw.empty? and grupa_pia.empty?
     @kierunki[name][:zajecia] << {:grupa => g, :zajecia_czw => grupa_czw, :zajecia_pia => grupa_pia}
   end

   render :layout => false
 end


end
