class ApplicationController < ActionController::Base
  include SessionsHelper
  require 'will_paginate/array'
end
