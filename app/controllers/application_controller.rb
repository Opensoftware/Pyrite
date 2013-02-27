# encoding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem

  filter_parameter_logging :password
  rescue_from(::ActionController::UnknownAction) {redirect_to :controller => 'main' }
  protect_from_forgery


# metoda pobiera informacje na temat obecnie ustawionego planu zajęć
# return @baza - identyfikator oznaczający nazwę bazy danych na której operuje system
  def get_current_plan
    #   @config = Setting.find(:first)
    #   case @config.current_plan
    #       when 0 : @baza = OldPlan
    #     when 1 : @baza = Plan
    #       when 2 : @baza = NewPlan
    #   end
    @baza = Plan
    return @baza
  end

  # pobranie aktualnego roku akademickiego
  def current_semester
    Schedule.find_by_id(Setting.first.try(:current_plan))
  end

  # pobieranie id planów ustawionych do edycji
  def getEditPlan
    return Setting.find(1).plan_to_edit
  end

  # pobranie id planu ustawionego do przeglądania
  def getViewPlan
    return Setting.find(1).current_plan
  end


  # pobranie bloków dla grup
  # bloki - tablica wpisów z bazy danych zawierająca wpisy dla grup
  def getblocs(bloki)
    for pl in bloki
      @Gz = (pl.godz.to_i / 60)
      @Mz = pl.godz.to_i - @Gz.minutes
      if (@Mz == 0 )
        @GMz = "#{@Gz}:#{@Mz}0"
      else
        @GMz = "#{@Gz}:#{@Mz}"
      end
      @gr = ""
      for g in pl.groups
        @gr += g.nazwa
        @gr += " "
      end
      @qwe[@GMz][pl.dni] = "#{pl.prowadzacy}::s.#{ pl.sala}::#{pl.dlugosc}h::#{pl.przedmiot}::#{pl.rodzaj}::ID:#{pl.id}::#{pl.budynek}"
    end
    return @qwe
  end

  # pobieranie bloków dla sal
  # bloki - tablica wpisów z bazy danych zawierające wpisy dla sal
  def getblocsroom(bloki)
    for pl in bloki
      @Gz = (pl.godz.to_i / 60)
      @Mz = pl.godz.to_i - @Gz.minutes
      if (@Mz == 0 )
        @GMz = "#{@Gz}:#{@Mz}0"
      else
        @GMz = "#{@Gz}:#{@Mz}"
      end
      @gr = ""
      for g in pl.groups
        @gr += g.nazwa
        @gr += " "
      end
      @qwe1[@GMz][pl.dni] = "#{pl.prowadzacy}::gr. #{@gr}::#{pl.dlugosc}h::#{pl.przedmiot}::#{pl.rodzaj}::ID:#{pl.id}::#{pl.budynek}"
    end
    return @qwe1
  end

  # pobieranie bloków z pełnymi informacjami
  # bloki - tablica wpisów z bazy danych zawierająca wpisy dla planów
  def getblocsall(bloki)
    for pl in bloki
      @Gz = (pl.godz.to_i / 60)
      @Mz = pl.godz.to_i - @Gz.minutes
      if (@Mz == 0 )
        @GMz = "#{@Gz}:#{@Mz}0"
      else
        @GMz = "#{@Gz}:#{@Mz}"
      end
      @gr = ""
      for g in pl.groups
        @gr += g.nazwa
        @gr += " "
      end
      @qwe[@GMz][pl.dni] = "#{pl.prowadzacy}::gr. #{@gr}::s. #{pl.sala}::#{pl.dlugosc}h::#{pl.przedmiot}::#{pl.sala}::#{pl.budynek}::#{pl.rodzaj}::ID:#{pl.id}::."
    end
    return @qwe
  end

  # pobranie informacji na temat okresów w których plan zajęc nie obowiązuje
  # date - zmienna reprezentujaca date która chcemy przyrównać (sprawdzić) do okresów
  def checkfreetime(date)
    @free = Freeday.find(:all)
    for i in @free

      if  (Date.parse(i.start.strftime("%Y-%m-%d %H:%M %p")) <= Date.parse(date) && Date.parse(date) <= Date.parse(i.stop.strftime("%Y-%m-%d %H:%M %p")))
        puts "++++"
        return false
      end
    end
    return true
  end

  # metoda zamieniająca angielską nazwe dnia tygodnia na polską
  # day - trzy literowa nazwa dnia tygodnia po angielsu
  # return @day polska nazwa dnia tygodnia
  def getpolishname(day)
    case day
    when "Mon"
      @day = "pon"
    when "Tue"
      @day = "wto"
    when "Wed"
      @day = "sro"
    when "Thu"
      @day = "czw"
    when "Fri"
      @day = "pia"
    when "Sat"
      @day = "sob"
    when "Sun"
      @day = "nie"
    end
    return @day
  end

  # metoda sprawdza występowanie danego bloku w planie zajęć i rezerwacji
  def GetConfict()
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
    return @jest
  end

  #zamienienie wartości przechowywane w bazie na godzinę
  # gz - int - odpowiednik godziny w bazie np( 600 => 10:00 )
  def GetHour(gz)
    @Gz = (gz.to_i / 60)
    @Mz = gz.to_i - @Gz.minutes
    if (@Mz == 0 )
      @GMz = "#{@Gz}:#{@Mz}0"
    else
      @GMz = "#{@Gz}:#{@Mz}"
    end
    @GMz
  end
end
