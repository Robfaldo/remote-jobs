class SendToErrorMonitors
  def self.send_error(error:, additional: {})
    Sentry.capture_exception(error, tags: additional)
    Rollbar.error(error, additional)
  end

  def self.send_notification(message:, additional: {})
    Sentry.capture_message("Message: #{message}. Additional info: #{additional.to_s}")
    Rollbar.info("Message: #{message}. Additional info: #{additional.to_s}")
  end
end
