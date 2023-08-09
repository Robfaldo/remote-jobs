require 'rails_helper'

describe JobServices::ParseStructuredJob do
  let(:job_preview) { instance_double(JobPreview, location: "Default job location") }

  def expected_error(error)
    hash_including(
      {
        error: a_kind_of(RuntimeError).and(having_attributes(message: error)),
        additional: {
          job_preview: job_preview
        }
      }
    )
  end

  describe '.location' do
    it 'raises an error when there is no jobLocation' do
      expect(SendToErrorMonitors).to receive(:send_error)
                                       .with(expected_error("jobLocation is not an Array or Hash"))

      described_class.new({}, job_preview).location
    end

    context 'when the jobLocation is an array' do
      it 'raises an error if job has no locations' do
        expect(SendToErrorMonitors).to receive(:send_error)
                                         .with(expected_error("structured_job has no jobLocations"))

        structured_job = { "jobLocation"=>[] }
        described_class.new(structured_job, job_preview).location
      end

      it 'raises an error if job has more than 1 location' do
        expect(SendToErrorMonitors).to receive(:send_error)
                                         .with(expected_error("structured_job has multiple jobLocations"))
        structured_job = {
          "jobLocation" => [
            {"@type"=>"Place", "address"=>{"@type"=>"PostalAddress", "addressCountry"=>"United Kingdom"}},
            {"@type"=>"Place", "address"=>{"@type"=>"PostalAddress", "addressCountry"=>"United Kingdom"}}
          ]
        }
        described_class.new(structured_job, job_preview).location
      end

      context 'when job has 1 location' do
        it 'raises an error if the address is missing' do
          expect(SendToErrorMonitors).to receive(:send_error)
                                           .with(expected_error("address does not exist on JobLocation"))
          structured_job = {
            "jobLocation" => [
              {"@type"=>"Place"}
            ]
          }
          described_class.new(structured_job, job_preview).location
        end

        it 'returns addressLocality when it exists' do
          structured_job = {
            "jobLocation" => [
              {
                "@type"=>"Place",
                "address"=> {
                  "@type"=>"PostalAddress",
                 "addressLocality"=>"Romford",
                 "addressRegion"=>"ENG",
                 "addressRegion1"=>"ENG",
                 "addressRegion2"=>"SE",
                 "addressCountry"=>"GB"
                }
              }
            ]
          }
          location = described_class.new(structured_job, job_preview).location
          expect(location).to eq("Romford")
        end

        it 'returns addressCountry if it exists (when addressLocality does not)' do
          structured_job = {
            "jobLocation" => [
              {
                "@type"=>"Place",
                "address"=> {
                  "@type"=>"PostalAddress",
                  "addressRegion"=>"ENG",
                  "addressRegion1"=>"ENG",
                  "addressRegion2"=>"SE",
                  "addressCountry"=>"GB"
                }
              }
            ]
          }
          location = described_class.new(structured_job, job_preview).location
          expect(location).to eq("GB")
        end

        it 'returns addressRegion if it exists (when addressLocality and addressCountry do not)' do
          structured_job = {
            "jobLocation" => [
              {
                "@type"=>"Place",
                "address"=> {
                  "@type"=>"PostalAddress",
                  "addressRegion"=>"ENG",
                  "addressRegion1"=>"ENG",
                  "addressRegion2"=>"SE"
                }
              }
            ]
          }
          location = described_class.new(structured_job, job_preview).location
          expect(location).to eq("ENG")
        end

        context 'if none of the jobLocation elements exist' do
          it 'returns the job preview' do
            structured_job = {
              "jobLocation" => [
                {
                  "@type"=>"Place",
                  "address"=> {
                    "@type"=>"PostalAddress"
                  }
                }
              ]
            }
            location = described_class.new(structured_job, job_preview).location

            expect(location).to eq(job_preview.location)
          end

          it 'raises an error' do
            expect(SendToErrorMonitors).to receive(:send_error)
                                             .with(expected_error("Couldn't find job location from array"))

            structured_job = {
              "jobLocation" => [
                {
                  "@type"=>"Place",
                  "address"=> {
                    "@type"=>"PostalAddress"
                  }
                }
              ]
            }
            described_class.new(structured_job, job_preview).location
          end
        end
      end
    end

    context 'when the jobLocation is a hash' do
      it 'raises an error if the address does not exist' do
        expect(SendToErrorMonitors).to receive(:send_error).with(expected_error("address does not exist on JobLocation"))

        structured_job = { "jobLocation"=> {} }
        described_class.new(structured_job, job_preview).location
      end

      it 'returns addressLocality when it exists' do
        structured_job = {
          "jobLocation"=>
            {
              "@type"=>"Place",
              "address"=> {
                "@type"=>"PostalAddress",
                "addressLocality"=>"Romford",
                "addressRegion"=>"ENG",
                "addressRegion1"=>"ENG",
                "addressRegion2"=>"SE",
                "addressCountry"=>"GB"
              }
            }
        }
        location = described_class.new(structured_job, job_preview).location
        expect(location).to eq("Romford")
      end

      it 'returns addressCountry if it exists (when addressLocality does not)' do
        structured_job = {
          "jobLocation"=>
            {
              "@type"=>"Place",
              "address"=> {
                "@type"=>"PostalAddress",
                "addressLocality"=>"Essex",
                "addressRegion1"=>"ENG",
                "addressRegion2"=>"SE",
                "addressCountry"=>"GB"
              }
            }
        }
        location = described_class.new(structured_job, job_preview).location
        expect(location).to eq("Essex")
      end

      it 'returns addressRegion if it exists (when addressLocality and addressCountry do not)' do
        structured_job = {
          "jobLocation"=>
            {
              "@type"=>"Place",
              "address"=> {
                "@type"=>"PostalAddress",
                "addressRegion"=>"ENG",
                "addressRegion2"=>"SE"
              }
            }
        }
        location = described_class.new(structured_job, job_preview).location
        expect(location).to eq("ENG")
      end

      context 'if none of the jobLocation elements exist' do
        it 'returns the job preview' do
          structured_job = {
            "jobLocation"=>
              {
                "@type"=>"Place",
                "address"=> {}
              }
          }
          location = described_class.new(structured_job, job_preview).location

          expect(location).to eq(job_preview.location)
        end

        it 'raises an error' do
          expect(SendToErrorMonitors).to receive(:send_error).with(expected_error("Couldn't find job location from hash"))

          structured_job = {
            "jobLocation"=>
              {
                "@type"=>"Place",
                "address"=> {}
              }
          }
          described_class.new(structured_job, job_preview).location
        end
      end
    end
  end
end
