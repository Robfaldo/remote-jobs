module Scraping
  class ApiRequestService
    class NotFoundResponse < StandardError; end
    class ApiScrapingError < StandardError; end
    class ApiErrorToRetry < StandardError; end
    class MaximumAttemptsReached < StandardError; end

    def self.call(number_of_attempts:, link:, scraper:, raise_error_after_attempts: true)
      retries ||= 0

      res = yield

      puts "#{scraper} Attempt #{retries + 1}: Response HTTP Status Code: #{ res.code }"
      puts "#{scraper} Attempt #{retries + 1}: Response HTTP Response Body: #{ res.body }"

      case res.code
      when 200, "200"
        return res
      when 404, "404"
        raise NotFoundResponse.new
      else
        raise ApiErrorToRetry.new
      end

    rescue NotFoundResponse => e
      raise NotFoundResponse.new("404 was returned by #{scraper}. Link: #{link}. Error: #{e}")
    rescue => e
      sleep 5
      retry if (retries += 1) < number_of_attempts

      if raise_error_after_attempts
        raise MaximumAttemptsReached.new("#{scraper} could not scrape after #{retries} attempts. Link: #{link}. Error: #{e}")
      end
    end
  end
end
