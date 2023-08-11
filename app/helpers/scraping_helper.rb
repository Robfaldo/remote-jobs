module ScrapingHelper
  def save_page(nokogiri_page)
    File.open('nokogiri_saved_webpage.html', 'w') { |file| file.write(nokogiri_page.to_html) }
  end

  def save_screenshot(response)
    File.open('nokogiri_screenshot.png', 'wb') { |file| file.write(response) }
  end
end
