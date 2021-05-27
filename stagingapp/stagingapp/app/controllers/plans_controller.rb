class PlansController < ApplicationController
  def index
    @plans = Plan.active
    fresh_when(@plans)
  end
end