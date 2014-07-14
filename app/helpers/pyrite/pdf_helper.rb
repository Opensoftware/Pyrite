module Pyrite
  module PdfHelper

    def set_font_family
      font_families.update("DejaVuSans" => {
        :normal => { :file => "#{Pyrite::Engine.root}/app/assets/fonts/pyrite/DejaVuSans.ttf" },
          :bold => { :file => "#{Pyrite::Engine.root}/app/assets/fonts/pyrite/DejaVuSans-Bold.ttf" },
          :italic => { :file => "#{Pyrite::Engine.root}/app/assets/fonts/pyrite/DejaVuSans-Oblique.ttf" }
      })
      font "DejaVuSans"
    end

    def draw_logo_with_title(title, subtitle, page_height)
      font_size 14
      bounding_box [bounds.left, bounds.top + 10], :width  => bounds.width do
        image "#{Pyrite::Engine.root}/app/assets/images/pyrite/pyrite_large.png", :scale => 0.4
      end
      text_box "#{I18n.t("pyrite.title_system_name")}", :at => [ bounds.left + 45, bounds.top - 5]
      font_size 8
      text_box "#{subtitle}", :at => [ bounds.left + 45, bounds.top - 22]
      if title.present?
        font_size 11
        text_box "#{title}", :align => :center, :at => [0, page_height - 30]
      end
    end


  end
end
