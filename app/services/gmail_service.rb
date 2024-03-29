require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

class GmailService # I'm just adding this class because I want to keep the stuff below for future reference but deployment breaks because this file didn't have this class defined. 
end

OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME = "Gmail API Ruby Quickstart".freeze
CREDENTIALS_PATH = "./config/credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_READONLY

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize
user_id = "me"



## I did this to scrape the gmail jobs alert email (but couldn't get the links working in the end)
# require 'nokogiri'
#
# message_list = service.list_user_messages user_id
#
# messages = message_list.messages.each {|message| service.get_user_message 'me', message.id}
#
# messages.each do |message|
#   jobs = []
#   email = service.get_user_message 'me', message.id
#
#   sender_email = email.payload.headers.find {|h| h.name.include?('From')}&.value
#   subject = email.payload.headers.find { |header| header.name == "Subject" }&.value
#
#   if sender_email.include?('Job alerts from Google')
#     parsed_email = Nokogiri::HTML.parse(email.payload.parts.last.body.data)
#     links = parsed_email.xpath('//a').map{|link| link.get_attribute('href')}
#
#
#     # Scrape the job
#
#
#   end
#
#   []
# end
