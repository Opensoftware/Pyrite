# encoding: UTF-8
class SiatkaController < ApplicationController

  require 'tcpdf'

  auto_complete_for :room, :numer
  auto_complete_for :lecturer, :lecture
  auto_complete_for :subject, :nazwa
  in_place_edit_for :plan, :dni

  before_filter :login_required, :except => [:drukujgrupe, :drukujsale, :showprow, :zestawienie]

  def render_404
    render :file => "public/404.html", :status => 404
  end

  def initialize()
     @i = 3
	   @blok = 0
	   @blok_ln = {'pon' => 0, 'wto' => 0, 'sro' => 0, 'czw'=> 0, 'pia' => 0}
     @j = 0
     @sal = Room.find(:all)
     @sa = Array.new(@sal.size)
     for s in @sal
      @sa[s.id] = s.numer;
     end
     @dlugosc = %w{1 2 3 4 5 6 7 8 9}
     @r = %w{W Ćw Lab}
     @dni1 = %w{pon wto sro czw pia sob nie}
     @dni = %w{pon wto sro czw pia}
     @czest = %w{1 2 3}

     @g1= %w{7:00 8:00 9:00 10:00 11:00 12:00 13:00 14:00 15:00 16:00 17:00 18:00 19:00 20:00}
     @gz= %w{7:00 8:00 9:00 10:00 11:00 12:00 13:00 14:00 15:00 16:00 17:00 18:00 19:00 20:00 21:00}
@listagodz = { "7:00" => "420", "7:15" => "435", "7:30" => "450", "7:45" => "465", "8:00" => "480", "8:15" => "495", "8:30" => "510", "8:45" => "525", "9:00" => "540", "9:15" => "555",  "9:30" => "570", "9:45" => "585", "10:00" => "600", "10:15" => "615", "10:30" => "630", "10:45" => "645", "11:00" => "660", "11:15" => "675", "11:30" => "690", "11:45" => "705", "12:00" => "720", "12:15" => "735", "12:30" => "750", "12:45" => "765", "13:00" => "780", "13:15" => "795", "13:30" => "810", "13:45" => "825", "14:00" => "840", "14:15" => "855", "14:30" => "870", "14:45" => "885", "15:00" => "900", "15:15" => "915", "15:30" => "930", "15:45" => "945", "16:00" => "960", "16:15" => "975", "16:30" => "990", "16:45" => "1005", "17:00" => "1020", "17:15" => "1035", "17:30" => "1050", "17:45" => "1065", "18:00" => "1080", "18:15" => "1095", "18:30" => "1110", "18:45" => "1125", "19:00" => "1140", "19:15" => "1155", "19:30" => "1170",  "19:45" => "1185", "20:00" => "1200", "20:15" => "1215", "20:30" => "1230", "20:45" => "1245", "21:00" => "1260" }.sort do |a,b|
    a[1].to_i <=> b[1].to_i
 end



     @godz1= %w{7:00 7:15 7:30 7:45 8:00 8:15 8:30 8:45 9:00 9:15 9:30 9:45 10:00 10:15 10:30 10:45 11:00 11:15 11:30 11:45 12:00 12:15 12:30 12:45 13:00 13:15 13:30 13:45 14:00 14:15 14:30 14:45 15:00 15:15 15:30 15:45 16:00 16:15 16:30 16:45 17:00 17:15 17:30 17:45 18:00 18:15 18:30 18:45 19:00 19:15 19:30 19:45 20:00 20:15 20:30 20:45}
     @godz= %w{7:00 7:15 7:30 7:45 8:00 8:15 8:30 8:45 9:00 9:15 9:30 9:45 10:00 10:15 10:30 10:45 11:00 11:15 11:30 11:45 12:00 12:15 12:30 12:45 13:00 13:15 13:30 13:45 14:00 14:15 14:30 14:45 15:00 15:15 15:30 15:45 16:00 16:15 16:30 16:45 17:00 17:15 17:30 17:45 18:00 18:15 18:30 18:45 19:00 19:15 19:30 19:45 20:00 20:15 20:30 20:45 21:00}
  #   @godz= %w{420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260}

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

  def drukujgrupe
		if !params[:grupa].nil?
			@grupy = Group.find(:all, :conditions => {:nazwa => params[:grupa]})
		else
			@grupy = Group.find(:all)
		end
#pobranie aktualnego roku akademickiego
		@rok = semestr

   pdf = TCPDF.new
   pdf.SetAutoPageBreak(false)

   doc_title = "Rozkład Zajęć semestr zimowy 2012/2013";
   doc_subject = "AGH";
   doc_keywords = "Plan zajęć";
  #set margins
   pdf.SetMargins(10, 15, 5);

		for gr in @grupy
      @tmp = gr.nazwa.split("")
      @tmp2 = @tmp[0].to_s + @tmp[1].to_s
      @kursy = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => @tmp2, :plan_id => getViewPlan})
      @grupa = Plan.find(:all, :include => 'groups', :conditions => {'groups.nazwa' => gr.nazwa, :plan_id => getViewPlan})
      @grupa += @kursy

      @gru = gr.nazwa.split("")
      @width = "120"
      @size = []
     56.times { |i|      @size << 35 + i * 4 }

		  pdf.AddPage();
 		  pdf.SetFont("FreeSans", "", 14);
 		  pdf.SetLineWidth(0.3)

  	  pdf.MultiCell(0, 5, "Rozkład Zajęć semestr zimowy #{@rok}/#{@rok.to_i + 1}", 0, 'C', 0, 1);
  		pdf.SetFont("FreeSans", "", 10);
  	  pdf.MultiCell(0, 5, "Rok #{@gru[0]}#{@gru[1]} #{@gru[2..5]}", 0, 'C', 0, 1);
 	    pdf.MultiCell(0, 5, "", 0, 'C', 0,1);
 		  pdf.SetFont("FreeSans", "", 6);

 		  pdf.MultiCell(20, 5, "Godzina", 1, 'C', 0,0);
 		  pdf.MultiCell(35, 5, "Poniedziałek", 1, 'C', 0, 0);
  	  pdf.MultiCell(35, 5, "Wtorek", 1, 'C', 0, 0);
 		  pdf.MultiCell(35, 5, "Środa", 1, 'C', 0,0);
 		  pdf.MultiCell(35, 5, "Czwartek", 1, 'C', 0,0);
 		  pdf.MultiCell(35, 5, "Piątek", 1, 'C', 0,1);
# GODZ
 		  @i = 1;
  		pdf.SetFont("FreeSans", "", 8);

		 for s in @g1
 		   pdf.MultiCell(20, 16 , "#{s}-#{@gz[@i]}", 1, 'C', 0,0);
 		   pdf.MultiCell(35, 16, "", 1, 'C',0,0);
 		   pdf.MultiCell(35, 16, "", 1, 'C',0,0);
 		   pdf.MultiCell(35, 16, "", 1, 'C',0,0);
 		   pdf.MultiCell(35, 16, "", 1, 'C',0,0);
		   pdf.MultiCell(35, 16, "", 1, 'C',0,1);
    	@i +=1
		 end
# tworzenie lini 15 minutowych

		 pdf.SetFont("FreeSans", "", 6);
		 pdf.SetLineWidth(0.1)

  	for i in @size
 	    pdf.Line(30,i.to_f,205,i.to_f)
  	end
 		for i in @grupa
 			@x1 = pozycjadnia(i.dni)
 		 	@y1 = pozycjagodz(i.godz)
  	 	i.budynek == "A0" ? @b="" : @b= "#{i.budynek},"
  	 	pdf.SetFont("FreeSans", "", 6);
   	 	pdf.SetXY(@x1,@y1)
   	 	if i.rodzaj == "W"
     		 pdf.SetFillColor(140,210,255)
   	 	else
    		 pdf.SetFillColor(245,246,171)
  	 	end

   	 	pdf.SetLineWidth(0.3)
  	 	pdf.MultiCell(35, i.dlugosc.to_i * 12,"", 1,'J',1)

 # pdf.SetXY(@x1,@y1)
 # pdf.Write(5, "#{i.godz}", '', 0);

  	 	pdf.SetXY(@x1+30,@y1)
	   	pdf.Write(5, "#{i.rodzaj}", '', 0);

   	 	pdf.SetXY(@x1,@y1+(i.dlugosc * 12)-5)
  	 	pdf.Write(5, "#{@b} sala #{i.sala} ", '', 0);

  	 	pdf.SetXY(@x1,@y1+(i.dlugosc.to_i * 4))
  	 	pdf.SetFont("FreeSans", "B", 6);
  	 	pdf.MultiCell(35,2, "#{i.przedmiot}",0,'C');

  	 	pdf.SetXY(@x1+3,@y1+(i.dlugosc.to_i * 4)+4)
   	 	pdf.SetFont("FreeSans", "", 5);
  	 	pdf.MultiCell(30,2, "#{i.prowadzacy}",0,'C');

		end
	end

# set document information
   pdf.SetCreator("Siatka Zajęć - by mtfk");
   pdf.SetAuthor("mtfk");
   pdf.SetTitle(doc_title);
   pdf.SetSubject(doc_subject);
   pdf.SetKeywords(doc_keywords);


    send_data pdf.Output, :filename => "plan.pdf", :type => "application/pdf"

	end

  def edit
    permit "moderator"
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
  end


  def sala

  end

  def preview
    flash[:notice] = ""
    @dodaj = Plan.new
		@plany = Array.new
		@kursy = Array.new
    if request.post?
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
    else
        @sale = Plan.find(:all)
        @plany = Plan.find(:all)
        respond_to do |format|
          format.html # index.html.erb
    		end
    end
    render :layout => false
  end

 #metoda odpowiedzialna za nieaktywnośc użytkownika
#  def update_activity_time
#    session[:expires_at] = 5.minutes.from_now
#  end

#  def session_expiry
#    @time_left = (session[:expires_at] - Time.now).to_i
#    unless @time_left > 0
#      reset_session
#      redirect_to :controller => :main
#    end
#  end


  def index
  end

  def uzup
   @sal = Room.find(:all)
   render :layout => false
  end

  def addr
  end

  def add
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
  end

  def del
     permit "moderator"
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
    @sp = Plan.find(:all, :conditions =>  ["id NOT LIKE '#{params[:dodaj][:id]}' AND sala = '#{params[:room][:numer]}' AND dni = '#{ params[:dodaj][:dni]}' AND plan_id = '#{getEditPlan}'"])
  # mtfk
  # tymczasowy fix na kolizje zajec ze starym semestrem
  #  @sp2 = Reservation.find(:all, :conditions => "sala = '#{params[:room][:numer]}' AND dni ='#{params[:dodaj][:dni]}' AND id NOT LIKE '#{params[:dodaj][:id]}' AND waznosc >= '#{Date.parse(Time.now.strftime('%d-%m-%Y'))}'")
    @sp2 = Reservation.find(:all, :conditions => "sala = '#{params[:room][:numer]}' AND dni ='#{params[:dodaj][:dni]}' AND id NOT LIKE '#{params[:dodaj][:id]}' AND waznosc >= '#{Date.parse('25-02-2013')}'")
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
      @sp = Plan.find(:all, :conditions => ["id NOT LIKE '#{params[:dodaj][:id]}' AND prowadzacy LIKE '#{params[:dodaj][:prowadzacy]}' AND plan_id = '#{getEditPlan}' AND dni LIKE '#{params[:dodaj][:dni]}' AND sala LIKE '#{params[:dodaj][:dni]}'"])
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
			@planid = Setting.find(:first)
			@pp = Plan.create(:plan_id => @planid.plan_to_edit , :godz => params[:dodaj][:godz], :katedra => params[:dodaj][:katedra], :dni => params[:dodaj][:dni], :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture], :czestotliwosc => params[:dodaj][:czestotliwosc],:przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi])
	  	for i in params[:dodaj][:grupa]
       @g = Group.find(:first, :conditions => {:nazwa => i})
			 @g.plans << @pp
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
 end

 def rrezerwacja
    @dodaj = Reservation.new
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
	      @sp = "";
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
      @kursy2 = Reservation.find_by_sql("SELECT * from reservations WHERE grupa LIKE '#{@tmp}' AND  waznosc LIKE '%#{Date.parse(params[:dodaj][:waznosc])}%'")
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
      		@sp1 =""
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
#       @dodaj = Reservation.create( :godz => params[:dodaj][:godz], :dni => @dzien, :grupa => params[:dodaj][:grupa], :dlugosc => params[:dodaj][:dlugosc], :sala => params[:room][:numer], :prowadzacy => params[:lecturer][:lecture],:przedmiot => params[:subject][:nazwa], :rodzaj => params[:dodaj][:rodzaj], :budynek => params[:dodaj][:budynek], :uwagi => params[:dodaj][:uwagi], :waznosc => Date.parse(params[:date]))
				params[:dodaj][:dni] = @dzien
				@dodaj = Reservation.create(params[:dodaj])
       @add = Array.new(@kom1)

     end
          redirect_to :action => "rezerwacja", :params => {:godz => params[:dodaj][:godz], :grupa => params[:dodaj][:grupa], :dlugosc => params[:dodaj][:dlugosc], :rodzaj => params[:dodaj][:rodzaj], :uwagi => params[:dodaj][:uwagi] }
#				redirect_to :action => "rezerwacja"
  end

 end

#sprawdzanie dostepnosci sal dla rezerwacji
 def formularz
    if params[:date].empty?
       @date = "1-01-2009"
    else
      @date = params[:date]
			@dzien = getpolishname(Date.parse(params[:date]).strftime("%a"))
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
      @sp = ""
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

	def konfiguracja
		permit 'moderator'
		@config = Setting.find(:first)
		if request.post?
			if !params[:config][:current_plan].nil? && !params[:config][:plan_to_edit].nil?
     		@config.current_plan = params[:config][:current_plan]
				@config.plan_to_edit = params[:config][:plan_to_edit]
				@config.save
			end
    else
    end
	end

	def drukowanie
		permit 'moderator'
	end
# metoda drukująca plany dla sal
	def drukujsale
		if !params[:sala].nil?
			@gr = Room.find(:all, :conditions => {:numer => params[:sala]})
		else
			@gr = Room.find(:all)
 		end

		@rok = semestr

    pdf = TCPDF.new
    pdf.SetAutoPageBreak(false)

  #set margins
   pdf.SetMargins(10, 15, 5);

			for sala in @gr
	      @grupa = Plan.find(:all, :conditions => {:sala => sala.numer, :plan_id => getEditPlan})
 	      @width = "120"
 	      @size = []
 		    56.times { |i|      @size << 35 + i * 4 }

    	  doc_title = "Rozkład Zajęć semestr zimowy 2012/2013";
     	  doc_subject = "AGH";
     	  doc_keywords = "Plan zajęć";
				 pdf.AddPage();
				 pdf.SetFont("FreeSans", "", 14);
				 pdf.SetLineWidth(0.3)

				 pdf.MultiCell(0, 5, "Rozkład Zajęć semestr zimowy #{@rok}/#{@rok.to_i + 1}", 0, 'C', 0, 1);
				 pdf.SetFont("FreeSans", "", 10);
				 pdf.MultiCell(0, 5, "Sala: #{sala.numer}", 0, 'C', 0, 1);
				 pdf.MultiCell(0, 5, "", 0, 'C', 0,1);
				 pdf.SetFont("FreeSans", "", 6);

				 pdf.MultiCell(20, 5, "Godzina", 1, 'C', 0,0);
				 pdf.MultiCell(35, 5, "Poniedziałek", 1, 'C', 0, 0);
				 pdf.MultiCell(35, 5, "Wtorek", 1, 'C', 0, 0);
				 pdf.MultiCell(35, 5, "Środa", 1, 'C', 0,0);
				 pdf.MultiCell(35, 5, "Czwartek", 1, 'C', 0,0);
				 pdf.MultiCell(35, 5, "Piątek", 1, 'C', 0,1);
			# GODZ
				@i = 1;
				 pdf.SetFont("FreeSans", "", 8);

			 for s in @g1
				 pdf.MultiCell(20, 16 , "#{s}-#{@gz[@i]}", 1, 'C', 0,0);
				 pdf.MultiCell(35, 16, "", 1, 'C',0,0);
				 pdf.MultiCell(35, 16, "", 1, 'C',0,0);
				 pdf.MultiCell(35, 16, "", 1, 'C',0,0);
				 pdf.MultiCell(35, 16, "", 1, 'C',0,0);
				 pdf.MultiCell(35, 16, "", 1, 'C',0,1);
			 @i +=1
			 end
			# tworzenie lini 15 minutowych

			 pdf.SetFont("FreeSans", "", 6);
			 pdf.SetLineWidth(0.1)

			 for i in @size
				 pdf.Line(30,i.to_f,205,i.to_f)
			 end
			 for i in @grupa

			 @x1 = pozycjadnia(i.dni)
			 @y1 = pozycjagodz(i.godz)
				 i.budynek == "A0" ? @b="" : @b= "#{i.budynek},"
				 pdf.SetFont("FreeSans", "", 6);
				 pdf.SetXY(@x1,@y1)
   	 	if i.rodzaj == "W"
     		 pdf.SetFillColor(140,210,255)
   	 	else
    		 pdf.SetFillColor(245,246,171)
  	 	end
				 pdf.SetLineWidth(0.3)
				 pdf.MultiCell(35, i.dlugosc.to_i * 12,"", 1,'J',1)

				 pdf.SetXY(@x1+30,@y1)
				 pdf.Write(5, "#{i.rodzaj}", '', 0);

				 pdf.SetXY(@x1,@y1+(i.dlugosc * 12)-5)
			@gr = ""
			for g in i.groups
				@gr += g.nazwa
				@gr += " "
			end
				 pdf.Write(5, "gr.#{@gr}", '', 0);

				 pdf.SetXY(@x1,@y1+(i.dlugosc.to_i * 4))
				 pdf.SetFont("FreeSans", "B", 6);
				 pdf.MultiCell(35,2, "#{i.przedmiot}",0,'C');

				 pdf.SetXY(@x1+3,@y1+(i.dlugosc.to_i * 4)+4)
				 pdf.SetFont("FreeSans", "", 5);
				 pdf.MultiCell(30,2, "#{i.prowadzacy}",0,'C');

			 end

      end

    # set document information
    pdf.SetCreator("Siatka Zajęć - by mtfk");
    pdf.SetAuthor("mtfk");
    pdf.SetTitle(doc_title);
    pdf.SetSubject(doc_subject);
    pdf.SetKeywords(doc_keywords);

    send_data pdf.Output, :filename => "plany.pdf", :type => "application/pdf"
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


		@rok = semestr
		render :layout => false
	end


end
