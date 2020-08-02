require 'rails_helper'

RSpec.describe JobFilteringService do

  before do
    Rails.application.load_seed # seed the test database
  end

  let(:job_filtering_service) { described_class.new }

  context 'when filtering by active' do
    before do
      create_job(active: true)
      create_job(active: true)
      create_job(active: false)
      create_job(active: false)
    end


    it 'will only return active jobs when passed active flag' do
      active_jobs = Job.where(active: true)

      response = job_filtering_service.call(active: true)

      expect(response.count).to eq(2)
      expect(response).to eq(active_jobs)
    end

    it 'will only return inactive jobs when passed inactive flag' do
      inactive_jobs = Job.where(active: false)

      response = job_filtering_service.call(active: false)

      expect(response.count).to eq(2)
      expect(response).to eq(inactive_jobs)
    end

    it 'will return all jobs if no active status flag is passed' do
      all_jobs = Job.all

      response = job_filtering_service.call

      expect(response.count).to eq(4)
      expect(response).to eq(all_jobs)
    end
  end

  context 'when filtering by stacks' do
    before do
      create_job(stack: Stack.backend, title: 'first job')
      second_job = create_job(stack: Stack.backend, title: 'second job')
      create_job(stack: Stack.frontend)
      create_job(stack: Stack.fullstack)
    end

    it 'returns the jobs with the correct stacks when given one stack' do
      response = job_filtering_service.call(stacks: [Stack.backend.id])

      expected_response = [
        Job.where(title: 'first job').first,
        Job.where(title: 'second job').first
      ]

      expect(response).to eq(expected_response)
    end

    it 'returns jobs with all stacks if no stacks are passed' do
      response = job_filtering_service.call(stacks: [])

      all_jobs = Job.all

      expect(response).to eq(all_jobs)
    end
  end
end

def create_job(
    active: true,
    stack: Stack.backend,
    title: 'test title'
)
  job = Job.new(
    active: active,
    published_date: Date.today,
    title: title,
    job_link: 'test link'
  )

  job.company = Company.where(name: 'test company1').first
  job.level = Level.where(name: 'mid').first
  job.stack = stack

  job.save
end
