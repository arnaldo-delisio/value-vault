# Orchestrates the full analysis: fetch stock data, call Claude, save analysis
class InvestorAnalysisService < BaseService
  def initialize(user:, ticker:, investor:, question:)
    @user = user
    @ticker = ticker.upcase.strip
    @investor = investor
    @question = question
  end

  def call
    # Check user limits
    return failure("Daily analysis limit reached") unless @user.can_analyze?

    # Fetch stock data
    stock_result = StockDataService.call(@ticker)
    return stock_result if stock_result.failure?

    stock_data = stock_result.data
    stock = Stock.find_by(ticker: @ticker)

    # Create pending analysis record
    analysis = Analysis.create!(
      user: @user,
      stock: stock,
      investor: @investor,
      question: @question,
      status: :pending
    )

    # Get AI analysis from Claude
    analysis.update!(status: :processing)

    claude_result = ClaudeService.call(
      investor: @investor,
      stock_data: stock_data,
      question: @question
    )

    if claude_result.success?
      analysis.update!(
        status: :completed,
        response: claude_result.data[:response],
        framework_data: {
          usage: claude_result.data[:usage],
          model: claude_result.data[:model]
        },
        completed_at: Time.current
      )

      success(analysis)
    else
      analysis.update!(
        status: :failed,
        error_message: claude_result.error
      )

      failure("Analysis failed: #{claude_result.error}")
    end
  rescue StandardError => e
    analysis&.update!(
      status: :failed,
      error_message: e.message
    )

    failure("Unexpected error: #{e.message}")
  end
end
