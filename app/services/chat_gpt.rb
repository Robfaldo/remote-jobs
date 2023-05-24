class ChatGpt
  def send_first_message(prompt)
    formatted_prompt = [{ role: "user", content: prompt }]
    response = send_message_with_history(formatted_prompt)
    response.dig("choices", 0, "message", "content")
  end

  private

  def send_message_with_history(conversation_history)
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: conversation_history,
        temperature: 0.7,
      })
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPEN_AI_TOKEN"])
  end
end
