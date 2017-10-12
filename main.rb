#gems required
#require 'sinatra'
require 'rubygems'
require 'twitter'
require 'yaml'
require 'erb'


class Search
	#returns tweets based on search input
	attr_reader :client, :search_terms, :time_limit, :rank, :no_of_tweets, :tweets

#twitter app login 
	def initialize(search_terms, days, no_of_tweets)
		@client = Twitter::REST::Client.new do |config|
		  	config.consumer_key        = "[INSERT YOUR CODE HERE]"
		  	config.consumer_secret     = "[INSERT YOUR CODE HERE]"
		  	config.access_token        = "[INSERT YOUR CODE HERE]"
		  	config.access_token_secret = "[INSERT YOUR CODE HERE]"
	  	end

	  	@search_terms = search_terms
	  	@time_limit = days
	  	@no_of_tweets = no_of_tweets
	end
	
	def tweets
	 	client.search("#{search_terms} AND -filter:retweets AND -filter:replies AND since:#{time_limit.time_adjusted}").to_a
	end

end

class TimeLimit
	attr_reader :days, :utc_limit

	def initialize(days)
		@days = days	
	end

	def time_adjusted 
		utc_conversion.to_date.to_s
	end

	def utc_conversion
		Time.now.utc - (60*60*24*@days)
	end

end

class SortResults
	attr_reader :tweets

	def initialize(tweets)
		@tweets = tweets
	end

	def favorite_count
		tweets.sort_by! do |tweet|
			tweet.favorite_count
		end
	end
end

class CropResults
	attr_reader :tweets, :search

	def initialize(tweets, search)
		@tweets = tweets
		@search = search
	end

	def crop
		tweets.slice!(search.no_of_tweets..-1)
	end

end

class DisplayResults
	attr_reader :tweets

	def initialize(tweets)
		@tweets = tweets
	end

	def display_url
		tweets.collect! do |tweet|
			tweet.url
		end
	end
end	


#use line 94 to customise search terms, time limit and number of tweets. Or use my defaults
search = Search.new('"web", "dev", "tips"', TimeLimit.new(days = 7), no_of_tweets = 10)
tweets = search.tweets
SortResults.new(tweets).favorite_count.reverse!
CropResults.new(tweets, search).crop
DisplayResults.new(tweets).display_url
puts tweets





