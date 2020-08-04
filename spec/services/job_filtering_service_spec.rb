require 'rails_helper'

RSpec.describe JobFilteringService do

  before do
    Rails.application.load_seed # seed the test database
  end

  let(:job_filtering_service) { described_class.new }
  let(:mid_level) { Level.where(name: "mid").first_or_create }
  let(:junior_level) { Level.where(name: "junior").first_or_create  }
  let(:senior_level) { Level.where(name: "senior").first_or_create  }
  let(:backend) { Stack.where(name: "backend").first_or_create }
  let(:frontend) { Stack.where(name: "frontend").first_or_create }
  let(:fullstack) { Stack.where(name: "fullstack").first_or_create }

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
      create_job(stack: backend, title: 'first job')
      create_job(stack: backend, title: 'second job')
      create_job(stack: frontend, title: 'third job')
      create_job(stack: fullstack)
    end

    it 'returns the jobs with the correct stacks when given one stack' do
      response = job_filtering_service.call(stacks: [backend.id])

      expected_response = [
        Job.where(title: 'first job').first,
        Job.where(title: 'second job').first
      ]

      expect(response).to eq(expected_response)
    end

    it 'returns the jobs with the correct stacks when given multiple stacks' do
      response = job_filtering_service.call(
          stacks: [backend.id, frontend.id]
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
                   stacks: ['invalid stack', frontend.id]
                 )
        }.to raise_error(JobFilteringService::InvalidStackProvided)
      end
    end
  end

  context 'when filtering by levels' do
    before do
      create_job(level: junior_level, title: 'first job')
      create_job(level: mid_level, title: 'second job')
      create_job(level: mid_level, title: 'third job')
      create_job(level: senior_level, title: 'fourth job')
    end

    it 'returns the jobs with the correct levels when given one level' do
      response = job_filtering_service.call(levels: [junior_level.id])

      expected_response = [
        Job.where(title: 'first job').first
      ]

      expect(response).to eq(expected_response)
    end

    it 'returns the jobs with the correct levels when given multiple levels' do
      response = job_filtering_service.call(
          levels: [junior_level.id, mid_level.id]
      )

      expected_response = [
          Job.where(title: 'first job').first,
          Job.where(title: 'second job').first,
          Job.where(title: 'third job').first
      ]

      expect(response).to eq(expected_response)
    end

    it 'returns jobs with all levels if no levels are passed' do
      response = job_filtering_service.call(levels: [])

      all_jobs = Job.all

      expect(response).to eq(all_jobs)
    end

    context 'when given an invalid stack' do
      xit 'raises a custom error' do
        expect{  job_filtering_service.call(
            stacks: ['invalid stack', frontend.id]
        )
        }.to raise_error(JobFilteringService::InvalidStackProvided)
      end
    end
  end

  context 'when filtering by multiple things' do
    it 'returns the correct jobs when you search for stack and active' do
      create_job(active: true, stack: backend, title: 'first job')
      create_job(active: false, stack: backend, title: 'second job')
      create_job(active: true, stack: frontend, title: 'third job')
      create_job(active: false, stack: fullstack, title: 'fourth job')

      response = job_filtering_service.call(
        stacks: [backend.id, frontend.id],
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
    stack: backend,
    title: 'test title',
    level: mid_level
)
  job = Job.new(
    active: active,
    published_date: Date.today,
    title: title,
    job_link: 'test link'
  )

  job.company = Company.where(name: 'test company1').first
  job.level = level
  job.stack = stack

  job.save
end