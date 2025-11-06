# Service to fetch and cache stock data from yfinance
class StockDataService < BaseService
  CACHE_DURATION = 30.minutes

  def initialize(ticker)
    @ticker = ticker.upcase.strip
  end

  def call
    stock = find_or_create_stock

    # Return cached data if fresh
    return success(stock.cached_data) unless stock.data_stale?

    # Fetch fresh data
    fetch_result = fetch_from_yfinance
    return fetch_result if fetch_result.failure?

    # Update stock with fresh data
    stock.update!(
      cached_data: fetch_result.data,
      data_fetched_at: Time.current,
      name: fetch_result.data["longName"] || fetch_result.data["shortName"]
    )

    success(stock.cached_data)
  rescue StandardError => e
    failure("Failed to fetch stock data: #{e.message}")
  end

  private

  def find_or_create_stock
    Stock.find_or_create_by!(ticker: @ticker)
  end

  def fetch_from_yfinance
    python_script = <<~PYTHON
      import yfinance as yf
      import json
      import sys

      try:
          ticker = sys.argv[1]
          stock = yf.Ticker(ticker)
          info = stock.info

          # Get historical data for additional metrics
          hist = stock.history(period="1y")

          # Build comprehensive data dict
          data = {
              "ticker": ticker,
              "longName": info.get("longName"),
              "shortName": info.get("shortName"),
              "price": info.get("currentPrice") or info.get("regularMarketPrice"),
              "previousClose": info.get("previousClose"),
              "open": info.get("open"),
              "dayLow": info.get("dayLow"),
              "dayHigh": info.get("dayHigh"),
              "fiftyTwoWeekLow": info.get("fiftyTwoWeekLow"),
              "fiftyTwoWeekHigh": info.get("fiftyTwoWeekHigh"),
              "volume": info.get("volume"),
              "averageVolume": info.get("averageVolume"),
              "marketCap": info.get("marketCap"),
              "beta": info.get("beta"),
              "peRatio": info.get("trailingPE") or info.get("forwardPE"),
              "eps": info.get("trailingEps"),
              "dividendYield": info.get("dividendYield"),
              "exDividendDate": info.get("exDividendDate"),
              "earningsGrowth": info.get("earningsGrowth"),
              "revenueGrowth": info.get("revenueGrowth"),
              "grossMargins": info.get("grossMargins"),
              "operatingMargins": info.get("operatingMargins"),
              "profitMargins": info.get("profitMargins"),
              "revenue": info.get("totalRevenue"),
              "netIncome": info.get("netIncomeToCommon"),
              "totalDebt": info.get("totalDebt"),
              "totalCash": info.get("totalCash"),
              "bookValue": info.get("bookValue"),
              "priceToBook": info.get("priceToBook"),
              "returnOnAssets": info.get("returnOnAssets"),
              "returnOnEquity": info.get("returnOnEquity"),
              "debtToEquity": info.get("debtToEquity"),
              "currentRatio": info.get("currentRatio"),
              "quickRatio": info.get("quickRatio"),
              "operatingCashflow": info.get("operatingCashflow"),
              "freeCashflow": info.get("freeCashflow"),
              "sector": info.get("sector"),
              "industry": info.get("industry"),
              "website": info.get("website"),
              "description": info.get("longBusinessSummary"),
              "fullTimeEmployees": info.get("fullTimeEmployees"),
              "52WeekChange": info.get("52WeekChange"),
              "recommendationKey": info.get("recommendationKey"),
              "targetMeanPrice": info.get("targetMeanPrice"),
              "numberOfAnalystOpinions": info.get("numberOfAnalystOpinions")
          }

          print(json.dumps(data))
      except Exception as e:
          print(json.dumps({"error": str(e)}), file=sys.stderr)
          sys.exit(1)
    PYTHON

    # Execute Python script using venv
    venv_python = Rails.root.join("venv", "bin", "python3")
    result = `#{venv_python} -c '#{python_script}' '#{@ticker}' 2>&1`

    if $?.success?
      data = JSON.parse(result)

      if data["error"]
        return failure(data["error"])
      end

      # Validate we got actual stock data
      if data["price"].nil? && data["marketCap"].nil?
        return failure("Invalid ticker symbol or no data available")
      end

      success(data)
    else
      failure("Failed to execute Python script: #{result}")
    end
  rescue JSON::ParserError => e
    failure("Failed to parse stock data: #{e.message}")
  rescue StandardError => e
    failure("Unexpected error: #{e.message}")
  end
end
