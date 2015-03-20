class NotificationGenerator
  @queue = :notifications_queue

  def self.perform(object)
    model = object["model"].to_sym

    case model
    when :status
      
      user = User.find(object["user_id"])

      subscriptions = Subscription.where(subscribee_id: user.id)

      subscriptions.each do |sub|
        sub.user.notify("#{user.username} has updated his status.")
      end

    end 

  end
end
