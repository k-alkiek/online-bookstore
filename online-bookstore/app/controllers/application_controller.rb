class ApplicationController < ActionController::Base
  include SessionsHelper
  def set_publisher
    @publisher = Publisher.find_by_sql("SELECT * FROM PUBLISHER Where Name = \"#{params[:id]}\"")[0]
  end
end
