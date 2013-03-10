PDFKit.configure do |config|
  #wkhtmltopdf integrated with pdfkit isn't the newest (have issues with page breaking in html tables),
  #download at least 0.10.0 version from http://code.google.com/p/wkhtmltopdf/downloads/list
  if RUBY_PLATFORM.include?("i686")
    config.wkhtmltopdf = "#{Rails.root}/bin/wkhtmltopdf-i386-0_11rc1"
  else
    config.wkhtmltopdf = "#{Rails.root}/bin/wkhtmltopdf-amd64-0_11rc1"
  end
  config.default_options = {
    :encoding=>"UTF-8",
    :page_size => 'A4',
    :print_media_type => true,
    "header-right" => "[page] / [topage]",
    "header-left" => "[doctitle]",
    "header-line" => true,
    "header-spacing" => 5,
    "margin-top" => "2.6cm",
    "margin-bottom" => "2.6cm"
  }
end
