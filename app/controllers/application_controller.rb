class ApplicationController < ActionController::Base
    prepend_before_action :require_no_authentication, only: :cancel
end
