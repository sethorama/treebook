desc "Clear all avatars"
task clear_avatars: :environment do
  User.find_each do |user|
    user.avatar = nil 
    user.save(validate: false)
  end 
end