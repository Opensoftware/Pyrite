# encoding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # include AuthenticatedSystem

  protect_from_forgery
  helper_method :flash_messages

  def flash_messages
    flash[:notice] || flash[:error] || nil
  end

  def after_sign_in_path_for(resource)
    dashboard_index_path
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
  # TODO deprecated TOREMOVE
  def checkfreetime(date)
    raise "This method is deprecated"
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
