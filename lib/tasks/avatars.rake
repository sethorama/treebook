desc "Clear all avatars"
task clear_avatars: :environment do
  User.update_all 'avatar = NULL'
end