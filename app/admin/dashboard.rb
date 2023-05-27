# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Total Job Statistics" do
          table_for ["approved", "rejected"] do
            column "Status", &:to_s

            column "Today" do |status|
              Job.public_send(status).where(created_at: Time.zone.now.beginning_of_day..Time.zone.now).count
            end

            column "Past 3 days" do |status|
              Job.public_send(status).where(created_at: 3.days.ago.beginning_of_day..Time.zone.now).count
            end

            column "Past Week" do |status|
              Job.public_send(status).where(created_at: 1.week.ago.beginning_of_day..Time.zone.now).count
            end

            column "Past Month" do |status|
              Job.public_send(status).where(created_at: 1.month.ago.beginning_of_day..Time.zone.now).count
            end
          end
        end

        panel "Linked Job Statistics" do
          table_for ["approved", "rejected"] do
            column "Status", &:to_s

            column "Today" do |status|
              Job.public_send(status)
                 .where(created_at: Time.zone.now.beginning_of_day..Time.zone.now, source: "linkedin").count
            end

            column "Past 3 days" do |status|
              Job.public_send(status)
                 .where(created_at: 3.days.ago.beginning_of_day..Time.zone.now, source: "linkedin").count
            end

            column "Past Week" do |status|
              Job.public_send(status)
                 .where(created_at: 1.week.ago.beginning_of_day..Time.zone.now, source: "linkedin").count
            end

            column "Past Month" do |status|
              Job.public_send(status)
                 .where(created_at: 1.month.ago.beginning_of_day..Time.zone.now, source: "linkedin").count
            end
          end
        end
      end
    end
  end
end
