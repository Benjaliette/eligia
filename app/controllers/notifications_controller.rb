class NotificationsController < ApplicationController
  before_action :set_notifications, only: :mark_as_read
  before_action :set_notification, only: :destroy

  def mark_as_read
    @notifications.each { |notif| notif.update(read: true) unless notif.read }
    render turbo_stream: turbo_stream.update('notif-icon', partial: 'shared/notification_badge', locals: { notifications: @notifications })
  end

  def destroy
    @notification.destroy
    redirect_to user_path(@notification.order.user), status: :see_other
  end

  private

  def set_notifications
    @notifications = current_user.notifications
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
