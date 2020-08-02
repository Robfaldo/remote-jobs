require 'rails_helper'

RSpec.describe JobFilteringService do

  context 'when filtering by active' do
    before do
      Rails.application.load_seed # seed the test database

      create_job(active: true)
      create_job(active: true)
      create_job(active: false)
      create_job(active: false)
    end


    it 'will only return active jobs when passed active flag' do
      active_jobs = Job.where(active: true)
      job_filtering_service = described_class.new

      response = job_filtering_service.call(active: true)

      expect(response.count).to eq(2)
      expect(response).to eq(active_jobs)
    end

    it 'will only return inactive jobs when passed inactive flag' do
      inactive_jobs = Job.where(active: false)
      job_filtering_service = described_class.new

      response = job_filtering_service.call(active: false)

      expect(response.count).to eq(2)
      expect(response).to eq(inactive_jobs)
    end

    it 'will return all jobs if no active status flag is passed' do
      all_jobs = Job.all
      job_filtering_service = described_class.new

      response = job_filtering_service.call

      expect(response.count).to eq(4)
      expect(response).to eq(all_jobs)
    end
  end
end

def create_job(active:)
  job = Job.new(
    active: active,
    published_date: Date.today,
    title: 'test title',
    job_link: 'test link'
  )

  job.company = Company.where(name: 'test company1').first
  job.level = Level.where(name: 'mid').first
  job.stack = Stack.where(name: 'backend').first

  job.save
end
