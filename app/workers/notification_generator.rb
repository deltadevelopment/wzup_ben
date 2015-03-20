class NotificationGenerator
  @queue = :notifications_queue

  def self.perform(object)
    model = object["model"].to_sym

    case model
    when :status
      
      subscriptions = Subscription.where(subscribee_id: object["user_id"])

      subscriptions.each do |sub|
        sub.user.notify('notified')
      end

    end 

  end
end
