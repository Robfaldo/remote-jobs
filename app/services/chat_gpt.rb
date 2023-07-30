class ChatGpt
  class NilResponseError < StandardError; end

  def send_first_message(prompt)
    formatted_prompt = [{ role: "user", content: prompt }]
    try_api_call(formatted_prompt)
  end

  private

  def try_api_call(formatted_prompt)
    Retryable.retryable(
      tries: 3,
      sleep: 3,
      on: [NilResponseError]
    ) do

      response = send_message_with_history(formatted_prompt)
      content = response.dig("choices", 0, "message", "content")

      if content.nil?
        # on the 4th time this is raised (i.e. tries + 1) the error will be
        # raised outside of retryable (so if NilResponseError if caught by rollbar it has
        # been retried 3 times already and it was only the 4th that was sent to rollbar)
        raise NilResponseError.new(formatted_prompt)
      end

      content
    end
  end

  def send_message_with_history(conversation_history)
    client.chat(
      parameters: {
        model: "gpt-4",
        messages: conversation_history,
        temperature: 0.2,
      })
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPEN_AI_TOKEN"])
  end
end
