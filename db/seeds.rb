# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'net/http'
require 'json'

# Clear existing Movie records before seeding
# puts "Destroying Movie Database..."
# # Movie.destroy_all
# puts "DESTROYED"

# base_url = "https://api.themoviedb.org/3/movie/popular"
# api_key = ENV['TMDB_API_KEY']

# page = 1
# max_pages = 500  # Limit to 500 pages
# total_movies = 0  # Initialize total movies counter

# while page <= max_pages
#   uri = URI("#{base_url}?api_key=#{api_key}&page=#{page}")
#   response = Net::HTTP.get(uri)
#   result = JSON.parse(response)

#   result['results'].each do |movie_hash|
#     next if Movie.exists?(title: movie_hash['title'])
#     next if Movie.exists?(overview: movie_hash['overview'])
#     next if movie_hash['overview'].blank?

#     # Create Movie records from the API response
#     Movie.create!(
#       title: movie_hash['title'],
#       overview: movie_hash['overview'],
#       poster_url: "https://image.tmdb.org/t/p/w500#{movie_hash['poster_path']}",
#       rating: movie_hash['vote_average']
#       # Add more fields as needed
#     )
#     total_movies += 1
#     # Add message after every 100 movies seeded
#     if total_movies % 100 == 0
#       puts "Seeded #{total_movies} movies..."
#     end
#   end

#   page += 1
# end

# puts "Finished fetching movies up to page #{max_pages}"
# puts "Total movies fetched: #{total_movies}"


puts "Entering List and Bookmarks Seeds"
puts "Destroying Lists"
List.destroy_all
puts "Destroyed Lists"

# Array of list names with associated image URLs
list_data = [
  { name: "horror", image_url: "https://res.cloudinary.com/ddzvfukq6/image/upload/v1720716160/production/751fg8r8w1q09gs8ku731wrxa8nk.jpg" },
  { name: "Comedy", image_url: "https://res.cloudinary.com/ddzvfukq6/image/upload/v1720716238/production/h9ft2s9oz748o92rxhwt0ndcmmz9.jpg" },
  { name: "Action", image_url: "https://res.cloudinary.com/ddzvfukq6/image/upload/v1720716314/production/kpqlolxggobm4kgruoc7b9bb14qz.jpg" },
  { name: "Romance", image_url: "https://res.cloudinary.com/ddzvfukq6/image/upload/v1720716348/production/cyfo0f7k7ckggzlmx401pdtey2g0.webp" },
  { name: "Autobio", image_url: "https://res.cloudinary.com/ddzvfukq6/image/upload/v1720716427/production/zlvf63257n2ahme9fsoiz4htmrho.jpg" },
  { name: "Sexuality", image_url: "https://res.cloudinary.com/ddzvfukq6/image/upload/v1720716542/production/b15ebe4dx69wgvku7m7orvf9htrd.png" }
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
list_data.each do |data|
  list = List.find_or_create_by(name: data[:name])
  puts "seeding #{data[:name]}"
  
  # Attach image from Cloudinary
  if list.photo.attached?
    list.photo.purge
  end
  list.photo.attach(
    io: URI.open(data[:image_url]),
    filename: "#{data[:name]}.jpg",
    content_type: 'image/jpeg'
  )
  puts "Attached image of #{data[:name]}"
end
puts "Done seeding Lists"

puts "Destroying Bookmarks"
Bookmark.destroy_all
puts "Destroyed Bookmarks"
puts "seeding Bookmarks..."
# Seed Bookmarks
bookmarks_attributes.each do |attributes|
  Bookmark.find_or_create_by(attributes)
end
puts "Done seeding Bookmarks"
puts "All done!"
