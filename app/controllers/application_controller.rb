class ApplicationController < ActionController::Base
  before_action :judge_pc_sp
  protect_from_forgery with: :exception
  def reload
    redirect_to("/")
  end

  # return -> :pc or :smartphone
  def judge_pc_sp
    @req = request.device_variant
  end
end
