# Service to interact with Claude API for investment analysis
class ClaudeService < BaseService
  API_ENDPOINT = "https://api.anthropic.com/v1/messages"
  MODEL = "claude-sonnet-4-20250514"
  MAX_TOKENS = 4096
  TEMPERATURE = 0.3 # Lower for more consistent analysis

  def initialize(investor:, stock_data:, question:)
    @investor = investor
    @stock_data = stock_data
    @question = question
    @api_key = ENV["ANTHROPIC_API_KEY"]
  end

  def call
    validate_api_key!

    # Build the request
    request_body = build_request_body

    # Call Claude API
    response = call_api(request_body)
    return response if response.failure?

    # Parse and return the response
    parse_response(response.data)
  rescue StandardError => e
    failure("Claude API error: #{e.message}")
  end

  private

  def validate_api_key!
    return if @api_key.present?

    raise "ANTHROPIC_API_KEY environment variable is not set"
  end

  def build_request_body
    {
      model: MODEL,
      max_tokens: MAX_TOKENS,
      temperature: TEMPERATURE,
      system: @investor.system_prompt,
      messages: [
        {
          role: "user",
          content: build_user_message
        }
      ]
    }
  end

  def build_user_message
    <<~MESSAGE
      Analyze #{@stock_data["ticker"]} (#{@stock_data["longName"]}) using your investment framework.

      STOCK DATA:
      #{format_stock_data(@stock_data)}

      USER QUESTION:
      #{@question}

      REQUIREMENTS:
      1. Apply your framework's quantitative criteria explicitly
      2. Show ALL calculations with actual numbers
      3. Search the web for recent news, earnings reports, or competitive threats
      4. Provide a clear recommendation (BUY/HOLD/PASS)
      5. Be specific and actionable - avoid generic advice
      6. Format your response with clear sections

      Remember: The user is relying on your specific framework and methodology.
      Use actual numbers from the data provided and show your work.
    MESSAGE
  end

  def format_stock_data(data)
    # Format key financial metrics in a readable way
    sections = []

    # Basic Info
    sections << "BASIC INFORMATION:"
    sections << "  Company: #{data['longName'] || data['shortName']}"
    sections << "  Ticker: #{data['ticker']}"
    sections << "  Sector: #{data['sector']}"
    sections << "  Industry: #{data['industry']}"
    sections << "  Employees: #{format_number(data['fullTimeEmployees'])}"
    sections << ""

    # Price & Valuation
    sections << "PRICE & VALUATION:"
    sections << "  Current Price: $#{format_number(data['price'], decimals: 2)}"
    sections << "  Market Cap: $#{format_large_number(data['marketCap'])}"
    sections << "  P/E Ratio: #{format_number(data['peRatio'], decimals: 2)}"
    sections << "  P/B Ratio: #{format_number(data['priceToBook'], decimals: 2)}"
    sections << "  52-Week Range: $#{format_number(data['fiftyTwoWeekLow'], decimals: 2)} - $#{format_number(data['fiftyTwoWeekHigh'], decimals: 2)}"
    sections << "  Beta: #{format_number(data['beta'], decimals: 2)}"
    sections << ""

    # Profitability
    sections << "PROFITABILITY & MARGINS:"
    sections << "  Revenue: $#{format_large_number(data['revenue'])}"
    sections << "  Net Income: $#{format_large_number(data['netIncome'])}"
    sections << "  Gross Margin: #{format_percent(data['grossMargins'])}"
    sections << "  Operating Margin: #{format_percent(data['operatingMargins'])}"
    sections << "  Profit Margin: #{format_percent(data['profitMargins'])}"
    sections << "  ROE: #{format_percent(data['returnOnEquity'])}"
    sections << "  ROA: #{format_percent(data['returnOnAssets'])}"
    sections << ""

    # Growth
    sections << "GROWTH:"
    sections << "  Revenue Growth: #{format_percent(data['revenueGrowth'])}"
    sections << "  Earnings Growth: #{format_percent(data['earningsGrowth'])}"
    sections << "  EPS: $#{format_number(data['eps'], decimals: 2)}"
    sections << ""

    # Financial Health
    sections << "FINANCIAL HEALTH:"
    sections << "  Total Debt: $#{format_large_number(data['totalDebt'])}"
    sections << "  Total Cash: $#{format_large_number(data['totalCash'])}"
    sections << "  Debt-to-Equity: #{format_number(data['debtToEquity'], decimals: 2)}"
    sections << "  Current Ratio: #{format_number(data['currentRatio'], decimals: 2)}"
    sections << "  Quick Ratio: #{format_number(data['quickRatio'], decimals: 2)}"
    sections << "  Book Value/Share: $#{format_number(data['bookValue'], decimals: 2)}"
    sections << ""

    # Cash Flow
    sections << "CASH FLOW:"
    sections << "  Operating Cash Flow: $#{format_large_number(data['operatingCashflow'])}"
    sections << "  Free Cash Flow: $#{format_large_number(data['freeCashflow'])}"
    sections << ""

    # Analyst Opinions
    if data['recommendationKey'] || data['targetMeanPrice']
      sections << "ANALYST CONSENSUS:"
      sections << "  Recommendation: #{data['recommendationKey']&.upcase}" if data['recommendationKey']
      sections << "  Target Price: $#{format_number(data['targetMeanPrice'], decimals: 2)}" if data['targetMeanPrice']
      sections << "  Number of Analysts: #{data['numberOfAnalystOpinions']}" if data['numberOfAnalystOpinions']
      sections << ""
    end

    sections.join("\n")
  end

  def format_number(num, decimals: 0)
    return "N/A" if num.nil?

    if decimals > 0
      "%.#{decimals}f" % num
    else
      num.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end
  end

  def format_large_number(num)
    return "N/A" if num.nil?

    if num >= 1_000_000_000_000
      "%.2fT" % (num / 1_000_000_000_000.0)
    elsif num >= 1_000_000_000
      "%.2fB" % (num / 1_000_000_000.0)
    elsif num >= 1_000_000
      "%.2fM" % (num / 1_000_000.0)
    else
      format_number(num)
    end
  end

  def format_percent(num)
    return "N/A" if num.nil?

    "#{(num * 100).round(2)}%"
  end

  def call_api(body)
    require "net/http"
    require "json"
    require "uri"

    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 60 # Claude can take a while

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request["x-api-key"] = @api_key
    request["anthropic-version"] = "2023-06-01"
    request.body = body.to_json

    response = http.request(request)

    if response.code.to_i == 200
      success(JSON.parse(response.body))
    else
      failure("API request failed: #{response.code} - #{response.body}")
    end
  rescue StandardError => e
    failure("Network error: #{e.message}")
  end

  def parse_response(api_response)
    # Extract the text content from Claude's response
    content = api_response.dig("content", 0, "text")

    if content.present?
      success({
        response: content,
        usage: api_response["usage"],
        model: api_response["model"]
      })
    else
      failure("No content in API response")
    end
  end
end
