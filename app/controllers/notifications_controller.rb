class NotificationsController < ApplicationController
  before_action :set_notifications, only: :mark_as_read

  def mark_as_read
    @notifications.each { |notif| notif.update(read: true) unless notif.read }
    render turbo_stream: turbo_stream.update('notif-icon', partial: 'shared/notification_badge', locals: { notifications: @notifications })
  end

  private

  def set_notifications
    @notifications = current_user.notifications
  end
end
