class ApplicationController < ActionController::Base
  def index
    @output = Pitcher.main
  end
end
