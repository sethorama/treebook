class UserNotifier < ActionMailer::Base
  default from: "noreply@treebook.com"

  ActionMailer::Base.smtp_settings = {
  :port           => ENV['MAILGUN_SMTP_PORT'],
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => 'https://sethoramabook.herokuapp.com',
  :authentication => :html
}
ActionMailer::Base.delivery_method = :smtp

  def friend_requested(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend

  	mail to: @friend.email,
  		subject: "#{@user.full_name} want to be friends on Treebook"
  end

  def friend_request_accepted(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend

  	mail to: @user.email,
  		subject: "#{@friend.full_name} has accepted your friend request"
  end
end


