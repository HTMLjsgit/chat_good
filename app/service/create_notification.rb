class CreateNotification
	include HTTParty

  	API_URI = 'https://onesignal.com/api/v1/notifications'.freeze

  	def self.call(*args)
  		new(*args).call
  	end

  	def initialize(contents:, type:, headings:, tags:)

  		@contents = contents
  		@type = type
      @tags = tags
      @headings = headings
  	end

  	def call
  		HTTParty.post(API_URI, headers: headers, body: body)
  	end

  	private

  	attr_reader :contents, :type, :headings, :tags

  	def headers
  		{
  			'Authorization' => "Basic #{ENV['RESTAPIKEY']}",
  			'Content-Type' => 'application/json' 
  		}
  	end

  	def body
  		{
  			'app_id' => ENV["ONEAPIKEY"],
  			'url' => 'localhost:3000',
  			'data' => { 'type': type},
  			'included_segments' => ['All'],
  			'contents' => contents,
        'tags' => tags,
        'headings' => headings
  		}.to_json
  	end
end