# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'uri'
require 'net/http'
require 'json'

# Clear existing Movie records before seeding
puts "Destroying Movie Database"
# Movie.destroy_all
puts "DESTROYED"

base_url = "https://api.themoviedb.org/3/movie/popular"
api_key = ENV['TMDB_API_KEY']

page = 1
max_pages = 500  # Limit to 500 pages
total_movies = 0  # Initialize total movies counter

while page <= max_pages
  uri = URI("#{base_url}?api_key=#{api_key}&page=#{page}")
  response = Net::HTTP.get(uri)
  result = JSON.parse(response)

  result['results'].each do |movie_hash|
    next if Movie.exists?(title: movie_hash['title'])
    next if Movie.exists?(overview: movie_hash['overview'])
    next if movie_hash['overview'].blank?

    # Create Movie records from the API response
    Movie.create!(
      title: movie_hash['title'],
      overview: movie_hash['overview'],
      poster_url: "https://image.tmdb.org/t/p/w500#{movie_hash['poster_path']}",
      rating: movie_hash['vote_average']
      # Add more fields as needed
    )
    total_movies += 1
    # Add message after every 100 movies seeded
    if total_movies % 100 == 0
      puts "Seeded #{total_movies} movies..."
    end
  end

  page += 1
end

puts "Finished fetching movies up to page #{max_pages}"
puts "Total movies fetched: #{total_movies}"


# seeds.rb
puts "Entering List and Bookmarks Seeds"
# Array of list names
list_names = [
  "horror",
  "Comedy",
  "Action",
  "Romance",
  "Autobio",
  "Sexuality"
]

# Array of bookmark attributes
bookmarks_attributes = [
  { comment: "Scary as hell!", movie_id: 902, list_id: 1 },
  { comment: "I would die laughing!", movie_id: 1850, list_id: 2 },
  { comment: "Amazing scenes!", movie_id: 41, list_id: 3 },
  { comment: "Cute and funny", movie_id: 210, list_id: 4 },
  { comment: "What the hell!", movie_id: 3143, list_id: 5 },
  { comment: "Uhm.. I dont know!", movie_id: 786, list_id: 6 }
]

puts "seeding Lists..."
# Seed Lists
list_names.each do |name|
  List.find_or_create_by(name: name)
  puts "seeding #{name}"
end
puts "Done seeding Lists"

puts "seeding Bookmarks..."
# Seed Bookmarks
bookmarks_attributes.each do |attributes|
  Bookmark.find_or_create_by(attributes)
end
puts "Done seeding Bookmarks"
puts "All done!"