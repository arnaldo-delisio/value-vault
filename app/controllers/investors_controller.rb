class InvestorsController < ApplicationController
  def index
    @investors = Investor.active.order(:name)
  end

  def show
    @investor = Investor.find(params[:id])
  end
end
