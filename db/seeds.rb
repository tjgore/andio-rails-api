# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#User.delete_all

#Users
user = User.new(first_name: "Mary", last_name: "Jane", email: "mary@gmail.com", password: 'password' )
user.image.attach(io: File.open('/usr/src/my-app/test/fixtures/files/image.jpg'),  filename: 'image.jpg' , content_type: "image/jpg")
user.save!

user = User.new(first_name: "Mat", last_name: "Lee", email: "mat@gmail.com", password: 'password' )
user.image.attach(io: File.open('/usr/src/my-app/test/fixtures/files/image.jpg'),  filename: 'image.jpg' , content_type: "image/jpg")
user.save!

user = User.new(first_name: "Sara", last_name: "Matthews", email: "sara@gmail.com", password: 'password' )
user.image.attach(io: File.open('/usr/src/my-app/test/fixtures/files/image.jpg'),  filename: 'image.jpg' , content_type: "image/jpg")
user.save!

user = User.new(first_name: "Jessica", last_name: "Peter", email: "jessica@gmail.com", password: 'password' )
user.image.attach(io: File.open('/usr/src/my-app/test/fixtures/files/image.jpg'),  filename: 'image.jpg' , content_type: "image/jpg")
user.save!

user = User.new(first_name: "Paul", last_name: "Joseph", email: "paul@gmail.com", password: 'password' )
user.image.attach(io: File.open('/usr/src/my-app/test/fixtures/files/image.jpg'),  filename: 'image.jpg' , content_type: "image/jpg")
user.save!

user = User.new(first_name: "Billy", last_name: "Ross", email: "billy@gmail.com", password: 'password' )
user.image.attach(io: File.open('/usr/src/my-app/test/fixtures/files/image.jpg'),  filename: 'image.jpg' , content_type: "image/jpg")
user.save!

#Requests, location:  Independence, KS 67301, USA
Request.create(title: "Picking up groceries", user_id: 1, location: "Riverside Park and Ralph Mitchell Zoo", latitude: 37.2032306, longitude: -95.8123535,  description: "Pick up apples, bread, milk, eggs, chips, jam, salt, and chicken breast Thank you", category: 'service')

Request.create(title: "Tools Needed", user_id: 1, location: "Super 8 by Wyndham Independence", latitude: 37.2097915, longitude: -95.7553115,  description: "I need some tools to finish repairing my car", category: 'material')

Request.create(title: "Digitize our books", user_id: 2, location: "Little House on the Prairie Museum", latitude: 37.1991085, longitude: -95.8094624,  description: "We need 2 young lads that can convert all our books into ebooks", category: 'service')

Request.create(title: "Towels needed", user_id: 2, location: "Jack Place
", latitude: 37.1570947, longitude: -95.6045667,  description: "We have 5 homless dogs in need of warm cozy blankets for the winter.", category: 'material')


