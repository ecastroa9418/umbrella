require "http"
require "json"

pp "Where are you located?"
user_location = gets.chomp.gsub(" ", "%20")

pp user_location

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(maps_url)

raw_response_maps = resp.to_s

parsed_response_maps = JSON.parse(raw_response_maps)

results = parsed_response_maps.fetch("results")

first_result = results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{latitude},#{longitude}"

# Place a GET request to the URL
raw_response_weather = HTTP.get(pirate_weather_url)

parsed_response_weather = JSON.parse(raw_response_weather)

currently_hash = parsed_response_weather.fetch("currently")

current_temp = currently_hash.fetch("temperature")

next_hour_hash = parsed_response_weather.fetch("hourly")

next_hour_array = next_hour_hash.fetch("data")

next_hour_hash = next_hour_array.at(0)

next_hour_summary = next_hour_hash.fetch("summary")

puts "It is currently F°#{current_temp} and in the next hour will be #{next_hour_summary}"
