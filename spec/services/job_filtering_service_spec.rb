require 'rails_helper'

RSpec.describe JobFilteringService do

  before do
    Rails.application.load_seed # seed the test database
  end

  let(:job_filtering_service) { described_class.new }

  context 'when filtering by active status' do
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
      create_job(stack: Stack.backend, title: 'second job')
      create_job(stack: Stack.frontend, title: 'third job')
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

    it 'returns the jobs with the correct stacks when given multiple stacks' do
      response = job_filtering_service.call(
          stacks: [Stack.backend.id, Stack.frontend.id]
      )

      expected_response = [
          Job.where(title: 'first job').first,
          Job.where(title: 'second job').first,
          Job.where(title: 'third job').first
      ]

      expect(response).to eq(expected_response)
    end

    it 'returns jobs with all stacks if no stacks are passed' do
      response = job_filtering_service.call(stacks: [])

      all_jobs = Job.all

      expect(response).to eq(all_jobs)
    end

    context 'when given an invalid stack' do
      it 'raises a custom error' do
        expect{  job_filtering_service.call(
                   stacks: ['invalid stack', Stack.frontend.id]
                 )
        }.to raise_error(JobFilteringService::InvalidStackProvided)
      end
    end
  end

  context 'when filtering by multiple things' do
    it 'returns the correct jobs when you search for stack and active' do
      create_job(active: true, stack: Stack.backend, title: 'first job')
      create_job(active: false, stack: Stack.backend, title: 'second job')
      create_job(active: true, stack: Stack.frontend, title: 'third job')
      create_job(active: false, stack: Stack.fullstack, title: 'fourth job')

      response = job_filtering_service.call(
        stacks: [Stack.backend.id, Stack.frontend.id],
        active: true
      )

      expected_response = [
        Job.where(title: 'first job').first,
        Job.where(title: 'third job').first
      ]

      expect(response).to eq(expected_response)
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
