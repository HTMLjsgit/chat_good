class CreateNotification
	include HTTParty

  	API_URI = 'https://onesignal.com/api/v1/notifications'.freeze

  	def self.call(*args)
  		new(*args).call
  	end

  	def initialize(contents:, type:, headings:, tags:, url:)

  		@contents = contents
  		@type = type
      @tags = tags
      @headings = headings
      @url = url
  	end

  	def call
  		HTTParty.post(API_URI, headers: headers, body: body)
  	end

  	private

  	attr_reader :contents, :type, :headings, :tags, :url

  	def headers
  		{
  			'Authorization' => "Basic #{ENV['RESTAPIKEY']}",
  			'Content-Type' => 'application/json' 
  		}
  	end

  	def body
  		{
  			'app_id' => ENV["ONEAPIKEY"],
  			'url' => url.to_s,
  			'data' => { 'type': type},
  			'included_segments' => ['All'],
  			'contents' => contents,
        'tags' => tags,
        'headings' => headings
  		}.to_json
  	end
end