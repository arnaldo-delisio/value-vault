class AnalysesController < ApplicationController
  before_action :authenticate_user!

  def index
    @analyses = current_user.analyses.recent.includes(:stock, :investor)
  end

  def new
    @investors = Investor.active.order(:name)
    @analysis = Analysis.new
  end

  def create
    investor = Investor.find(params[:investor_id])

    result = InvestorAnalysisService.call(
      user: current_user,
      ticker: params[:ticker],
      investor: investor,
      question: params[:question]
    )

    if result.success?
      @analysis = result.data
      redirect_to analysis_path(@analysis), notice: "Analysis completed successfully!"
    else
      flash.now[:alert] = result.error
      @investors = Investor.active.order(:name)
      @analysis = Analysis.new
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @analysis = current_user.analyses.includes(:stock, :investor).find(params[:id])
  end
end
