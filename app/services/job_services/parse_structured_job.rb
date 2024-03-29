module JobServices
  class ParseStructuredJob
    def initialize(structured_job, job_preview)
      @structured_job = structured_job
      @job_preview = job_preview
    end

    def location
      if structured_job["jobLocation"].is_a?(Array)
        location_from_array_job_location
      elsif structured_job["jobLocation"].is_a?(Hash)
        location_from_hash_job_location
      else
        raise "jobLocation is not an Array or Hash"
      end
    rescue => e
      SendToErrorMonitors.send_error(
        error: e,
        additional: {
          job_preview: job_preview,
        }
      )

      # default to the job preview location
      job_preview.location
    end

    private

    attr_reader :structured_job, :job_preview

    def location_from_hash_job_location
      address = structured_job["jobLocation"]["address"]
      raise "address does not exist on JobLocation" if address.nil?

      final_location = extract_location(address)

      if final_location
        return final_location
      else
        raise "Couldn't find job location from hash"
      end
    end

    def location_from_array_job_location
      if structured_job["jobLocation"].empty?
        # I'm not sure if this will ever actually occur - if it does i'll add some logic to handle it
        raise "structured_job has no jobLocations"
      elsif structured_job["jobLocation"].count > 1
        # I'm not sure if this will ever actually occur - if it does i'll add some logic to handle it
        raise "structured_job has multiple jobLocations"
      else
        address = structured_job["jobLocation"].first["address"]
        raise "address does not exist on JobLocation" if address.nil?

        final_location = extract_location(address)

        if final_location
          return final_location
        else
          raise "Couldn't find job location from array"
        end
      end
    end

    def extract_location(address)
      if address.dig("addressLocality")
        return address.dig("addressLocality") if address.dig("addressLocality").length > 0
      elsif address.dig("addressCountry")
        return address.dig("addressCountry") if address.dig("addressCountry").length > 0
      elsif address.dig("addressRegion")
        return address.dig("addressRegion") if address.dig("addressRegion").length > 0
      end
    end
  end
end
