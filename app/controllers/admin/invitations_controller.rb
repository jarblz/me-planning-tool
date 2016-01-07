class Admin::InvitationsController < Devise::InvitationsController
  before_action :authenticate_admin, only: [:new]


  def authenticate_admin
    if !current_user.admin?
      redirect_to root_url, alert: "You must be an admin to see that page!"
    end
  end
end

def authenticate_admin
  if !current_user.admin?
    redirect_to root_url, alert: "You must be an admin to see that page!"
  end
end
