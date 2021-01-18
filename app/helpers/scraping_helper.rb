module ScrapingHelper
  def save_page(nokogiri_page)
    File.open('nokogiri_saved_webpage.html', 'w') { |file| file.write(nokogiri_page.to_html) }
  end
end