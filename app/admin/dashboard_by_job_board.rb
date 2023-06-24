# frozen_string_literal: true
ActiveAdmin.register_page "DashboardByJobBoard" do
  menu priority: 1, label: "Dashboard by Job Board"

  content title: "Dashboard by Job Board" do
    columns do
      column do
        ['indeed', 'linkedin'].each do |job_board|
          panel job_board.upcase do
            panel "Jobs at each status based on when the job was created" do
              table_for ["scraped", "filtered", "evaluated", "total"] do
                column "Status", &:to_s

                column "Created today" do |status|
                  Job.public_send(status)
                     .where(created_at: Time.zone.now.beginning_of_day..Time.zone.now)
                     .where(source: job_board)
                     .count
                end

                column "Created past 3 days" do |status|
                  Job.public_send(status)
                     .where(created_at: 3.days.ago.beginning_of_day..Time.zone.now)
                     .where(source: job_board)
                     .count
                end

                column "Created past week" do |status|
                  Job.public_send(status)
                     .where(created_at: 1.week.ago.beginning_of_day..Time.zone.now)
                     .where(source: job_board)
                     .count
                end

                column "Created past Month" do |status|
                  Job.public_send(status)
                     .where(created_at: 1.month.ago.beginning_of_day..Time.zone.now)
                     .where(source: job_board)
                     .count
                end
              end
            end

            panel "Job Previews at each status based on when the job preview was created" do
              table_for ["scraped", "filtered", "evaluated", "total"] do
                column "Status", &:to_s

                column "Created today" do |status|
                  JobPreview.public_send(status)
                            .where(created_at: Time.zone.now.beginning_of_day..Time.zone.now)
                            .where(source: job_board)
                            .count
                end

                column "Created past 3 days" do |status|
                  JobPreview.public_send(status)
                            .where(created_at: 3.days.ago.beginning_of_day..Time.zone.now)
                            .where(source: job_board)
                            .count
                end

                column "Created past week" do |status|
                  JobPreview.public_send(status)
                            .where(created_at: 1.week.ago.beginning_of_day..Time.zone.now)
                            .where(source: job_board)
                            .count
                end

                column "Created past Month" do |status|
                  JobPreview.public_send(status)
                            .where(created_at: 1.month.ago.beginning_of_day..Time.zone.now)
                            .where(source: job_board)
                            .count
                end
              end
            end
          end
        end
      end
    end
  end
end
