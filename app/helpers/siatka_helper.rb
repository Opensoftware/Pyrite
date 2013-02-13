module SiatkaHelper
#require 'maruku'

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
 
def markdown(text)
    text.blank? ? "" : Maruku.new(text).to_html
end 
end
