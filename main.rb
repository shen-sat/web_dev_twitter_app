#gems required
#require 'sinatra'
require 'rubygems'
require 'twitter'
require 'yaml'
require 'erb'

#sinatra bit of code - displays the html code constructed by making a new Begin class object and then calling the method init_app on that object


#This is code for the 'Begin' class which has a method (init_app, which draws data from Twitter and constructs the html code).
#Sinatra will call an object from this class and then run the def_init method on that object to run its associated code.
#The def_init method returns html code (ruby methods return whatever value is produced last) which is needed by Sinatra to render the webpage.
class Search
	#returns tweets based on search input
	attr_reader :client, :search_terms, :time_limit, :rank, :no_of_tweets, :tweets

	def initialize(search_terms, days, opts = {})
		@client = Twitter::REST::Client.new do |config|
		  	config.consumer_key        = "t3F5fBiVwUjsZyzxAcpDWGHF4"
		  	config.consumer_secret     = "YjEpZWx5xQYZ8RD82Dbgutd4m7kytoa3H3nvcppAVOy56LmhSe"
		  	config.access_token        = "2347401997-3PzoVOwfAUCr5BVQJ4VmyooGGBXSlcMxV433NDs"
		  	config.access_token_secret = "kAkks0m2oWbKb2H9z874f6fMEsquH5xvdB6Tdm7CS95CQ"
	  	end

	  	@search_terms = search_terms
	  	@time_limit = days
	  	@rank = opts[:rank]
	  	@no_of_tweets = opts[:no_of_tweets]
	 end

	 def perform_search
	 	puts time_limit.time_adjusted
	 	@tweets = client.search("#{search_terms} AND since:#{time_limit.time_adjusted}").to_a
	 	puts tweets[0].url
	 end

 	
=begin
		#get the time limit for 24 hours before the time of search and convert it to string 
		yesterday_time = Time.now.utc - (60*60*24)
		search_date_limit = yesterday_time.to_date.to_s

		#set up an array to collect the tweets from the search
		todays_pixelart_tweets = [] 

		#set the search operators. These are regular search operators that can be used within Twitter itself. 
		pixel_art_tweets = client.search("#pixelart AND filter:images AND -filter:retweets AND -filter:replies AND since:#{search_date_limit}")

		#for each tweet in previous search, make sure it has media, make sure that media is a pic and make sure it was created by the ime set previously.
		#This bit of code also has a .dup method -- this takes variables that can't be modified (eg tweet.created_at) and duplicates it so it can be modified.
		#In this code it is modified to display time in UTC (ie that's what the .utc method is for)
		pixel_art_tweets.each do |tweet|
			if tweet.media? && tweet.media[0].attrs[:type] == "photo" && tweet.created_at.dup.utc > yesterday_time
				todays_pixelart_tweets.push(tweet)
			end
		end
=end
		#puts todays_pixelart_tweets[0] || "No tweets found"
end

class TimeAdjust
	#converts time to UTC date string
	attr_reader :days, :utc_limit, :date_limit

	def initialize(days)
		@days = days	
	end

	def time_adjusted
		@utc_limit = Time.now.utc - (60*60*24*@days)
		@date_limit = @utc_limit.to_date.to_s
	end

end




search = Search.new("apocalyspe", TimeAdjust.new(1)) 
search.perform_search



