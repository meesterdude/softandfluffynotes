class ApplicationController < ActionController::Base
  protect_from_forgery

  # overwriting devise redirects
  def after_sign_out_path_for(resource)
    notes_index_url
  end
  def after_sign_in_path_for(resource)
    notes_index_url
  end
end
