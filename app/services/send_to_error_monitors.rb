class SendToErrorMonitors
  def self.send_error(error:, additional: {})
    Rollbar.error(error, additional)
  end

  def self.send_notification(message:, additional: {})
    Rollbar.info("Message: #{message}. Additional info: #{additional.to_s}")
  end
end
