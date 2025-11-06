# Value Vault - Build Plan & Status

**Project:** AI-powered investment analysis tool with legendary investor personas
**Status:** ✅ Demo-ready (November 2025)
**Purpose:** Demonstrate Rails proficiency + Financial Advisor background for Zipline application
**Tech Stack:** Rails 7.2.3, PostgreSQL, Hotwire, Tailwind CSS, Claude API
**Timeline:** Built in focused sessions (November 2025)

---

## ✅ Current Status (November 2025)

**What's Built:**
- ✅ Core analysis feature: Single ticker + investor selection + question input
- ✅ 5 investor personas with custom frameworks (Munger, Buffett, Lynch, Graham, Dalio)
- ✅ Stock data integration via yfinance (Python subprocess)
- ✅ Claude AI integration with structured prompts
- ✅ User authentication (Devise) with tier system (free/pro/enterprise)
- ✅ Responsive UI with Tailwind CSS + Hotwire
- ✅ Mobile-responsive navigation with hamburger menu
- ✅ Analysis history and results viewing
- ✅ Markdown rendering for AI responses
- ✅ Database schema with proper relationships
- ✅ Service object architecture (StockDataService, ClaudeService, InvestorAnalysisService)
- ✅ Caching for stock data (30-minute expiry)
- ✅ Demo account seeded for testing

**What's Missing (Future Enhancements):**
- Background jobs (currently synchronous - acceptable for demo)
- Portfolio analysis (multi-stock comparison)
- Multiple investor comparison mode
- Historical tracking & analytics
- Stripe integration (tier upgrades)
- Comprehensive test coverage
- Production deployment

**Demo URL:** (Deploy when ready for Enrica/Zipline team)

**Purpose:**
This project demonstrates:
1. Rails 7 proficiency (MVC, migrations, service objects, Hotwire)
2. Financial domain knowledge (actual investor frameworks, not generic AI)
3. AI integration (Claude API with structured prompts)
4. Full-stack capability (backend + frontend + database)
5. Production thinking (authentication, caching, error handling)

**Next Steps:**
1. Get feedback from Enrica and Zipline team
2. Deploy to Railway/Heroku for live demo
3. After job secured: Decide on open source + hosted strategy

---

## 🎯 Project Vision

**What it does:**
- Chat interface with AI personas of famous investors (Munger, Buffett, Lynch, Graham, Dalio)
- Real-time stock data from yfinance
- Web search integration for current market context
- **REAL investor frameworks** - not generic AI fluff
- Multi-investor analysis (compare perspectives)
- Portfolio analysis
- Production-ready: caching, rate limiting, authentication, monetization

**What makes it special:**
- Actual quantitative frameworks (Munger's kill switches, Buffett's DCF, Lynch's PEG)
- Web search for current events/news
- Multiple investors simultaneously
- Open source
- Built in 48 hours as a learning project

---

## 📁 Project Structure

```
value-vault/
├── PLAN.md (this file)
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DATABASE_SCHEMA.md
│   ├── INVESTOR_FRAMEWORKS.md
│   ├── API_CONTRACTS.md
│   └── DEPLOYMENT.md
├── app/
│   ├── components/          # ViewComponents
│   ├── jobs/               # Background jobs
│   ├── services/           # Business logic
│   │   ├── base_service.rb
│   │   ├── stock_data_service.rb
│   │   ├── claude_service.rb
│   │   ├── investor_analysis_service.rb
│   │   └── frameworks/     # Investor-specific frameworks
│   │       ├── munger_framework_service.rb
│   │       ├── buffett_framework_service.rb
│   │       ├── lynch_framework_service.rb
│   │       ├── graham_framework_service.rb
│   │       └── dalio_framework_service.rb
│   ├── models/
│   │   ├── user.rb
│   │   ├── investor.rb
│   │   ├── analysis.rb
│   │   ├── stock.rb
│   │   └── portfolio.rb
│   └── controllers/
│       ├── analyses_controller.rb
│       ├── portfolios_controller.rb
│       └── investors_controller.rb
├── spec/                   # RSpec tests
└── README.md
```

---

## 🗄️ Database Schema

```ruby
# == Schema Information
#
# Table: users
#  id              :bigint
#  email           :string
#  encrypted_password :string
#  tier            :integer (enum: free, pro, enterprise)
#  analyses_count  :integer default(0)
#  created_at      :datetime
#  updated_at      :datetime
#
# Table: investors
#  id              :bigint
#  name            :string (Warren Buffett, Charlie Munger, etc.)
#  persona         :integer (enum)
#  system_prompt   :text
#  framework_config :jsonb (framework-specific parameters)
#  avatar_url      :string
#  active          :boolean default(true)
#  analyses_count  :integer default(0)
#  created_at      :datetime
#  updated_at      :datetime
#
# Table: stocks
#  id              :bigint
#  ticker          :string (AAPL, MSFT, etc.)
#  name            :string
#  cached_data     :jsonb (from yfinance)
#  data_fetched_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#
# Table: analyses
#  id              :bigint
#  user_id         :bigint
#  stock_id        :bigint
#  investor_id     :bigint
#  question        :text
#  response        :text (AI response)
#  framework_data  :jsonb (kill switches, calculations, etc.)
#  status          :integer (pending, processing, completed, failed)
#  error_message   :text
#  completed_at    :datetime
#  created_at      :datetime
#  updated_at      :datetime
#
# Table: portfolios
#  id              :bigint
#  user_id         :bigint
#  name            :string
#  stock_tickers   :jsonb (array of tickers)
#  created_at      :datetime
#  updated_at      :datetime
```

---

## 🏗️ Architecture Patterns

### Service Objects (Business Logic)

All business logic lives in service objects following this pattern:

```ruby
# app/services/base_service.rb
class BaseService
  def self.call(...)
    new(...).call
  end

  private

  def success(data)
    Result.new(success: true, data: data)
  end

  def failure(error)
    Result.new(success: false, error: error)
  end
end

Result = Struct.new(:success, :data, :error, keyword_init: true) do
  def success?
    success
  end

  def failure?
    !success
  end
end
```

### Framework Services

Each investor has a framework service that implements their ACTUAL investment methodology:

```ruby
# app/services/frameworks/munger_framework_service.rb
class Frameworks::MungerFrameworkService < BaseService
  # Implements Munger's kill switches and mental models
  # Returns structured analysis with quantitative metrics
end
```

### ViewComponents (UI)

Reusable, testable UI components:

```ruby
# app/components/investor_avatar_component.rb
class InvestorAvatarComponent < ViewComponent::Base
  # Renders investor selection avatars
end
```

### Background Jobs (Async Processing)

```ruby
# app/jobs/analysis_job.rb
class AnalysisJob < ApplicationJob
  # Processes AI analysis asynchronously
  # Updates via Turbo Streams
end
```

---

## 🧠 Investor Frameworks (CRITICAL)

### Charlie Munger - Kill Switches + Mental Models

**Kill Switches (Hard Stops):**
1. Debt-to-Equity > 60% → REJECT
2. ROIC < 15% → REJECT
3. Management issues → REJECT
4. P/E > 25 (without exceptional moat) → REJECT
5. Declining margins → REJECT
6. No competitive advantage → REJECT
7. Cyclical peak → REJECT

**Mental Models Applied:**
- Psychology: Incentives, biases, Lollapalooza effects
- Economics: Moat analysis, pricing power
- Math: ROIC calculations, margin analysis
- Biology: Competitive dynamics

**Implementation:**
```ruby
# Returns structured result with:
{
  kill_switches_triggered: [
    { switch: :high_leverage, value: 0.75, threshold: 0.6, explanation: "..." }
  ],
  mental_model_score: 45, # 0-100
  recommendation: "PASS - 2 kill switches triggered",
  detailed_reasoning: { ... }
}
```

### Warren Buffett - Economic Moat + Intrinsic Value

**Framework:**
1. Economic Moat Analysis (qualitative + quantitative)
2. Owner Earnings Calculation
3. Intrinsic Value (DCF with owner earnings)
4. Margin of Safety (price vs intrinsic value)

**Moat Indicators:**
- Brand strength (quantified by brand value rank)
- Switching costs (customer retention rate)
- Network effects (user growth metrics)
- Cost advantages (gross margin vs industry)
- Regulatory barriers (binary check)

**Owner Earnings Formula:**
```
Net Income + Depreciation - CapEx - Working Capital Increase
```

**Intrinsic Value (DCF):**
- 10-year projection of owner earnings
- Conservative growth assumptions
- 9% discount rate (Buffett's minimum hurdle)
- Terminal value with 0% growth

**Recommendation Criteria:**
- Margin of Safety ≥ 50%: STRONG BUY
- Margin of Safety ≥ 30%: BUY
- Margin of Safety ≥ 15%: HOLD
- Margin of Safety < 15%: PASS

### Peter Lynch - GARP (Growth at Reasonable Price)

**Key Metrics:**
- PEG Ratio (P/E / Growth Rate)
  - < 1.0: Undervalued
  - 1.0-1.5: Fair value
  - > 2.0: Overvalued

**Lynch's 6 Categories:**
1. Fast Growers (growth > 20%)
2. Stalwarts (growth 10-20%)
3. Slow Growers (growth < 10%, dividend focus)
4. Cyclicals (timing-dependent)
5. Turnarounds (high risk)
6. Asset Plays (hidden value)

**Growth Quality Checks:**
- Revenue growth matches earnings growth
- Debt manageable (D/E < 0.5)
- Insider buying
- Institutional ownership 30-60%
- P/E to growth attractive

### Benjamin Graham - Margin of Safety

**Quantitative Criteria:**
- P/E < 15
- P/B < 1.5
- P/E × P/B < 22.5
- Debt-to-Equity < 1.0
- Current Ratio > 2.0
- Positive earnings for 10 years
- No earnings decline > 5% in last 10 years

**Implementation:**
Graham's framework is purely quantitative - pass/fail on metrics.

### Ray Dalio - Economic Machine + All Weather

**Framework:**
- Economic cycle analysis
- Asset correlation
- Risk parity
- Diversification metrics

**Implementation:**
Focus on portfolio-level analysis, not individual stocks.

---

## 🔌 External Integrations

### 1. Stock Data (yfinance)

**Option A: Python subprocess (quick)**
```ruby
def fetch_from_yfinance
  command = <<~PYTHON
    import yfinance as yf
    import json
    stock = yf.Ticker('#{@ticker}')
    print(json.dumps(stock.info))
  PYTHON

  result = `python3 -c "#{command}"`
  JSON.parse(result)
end
```

**Option B: Ruby gem (cleaner)**
```ruby
# Gemfile
gem 'yahoo-finance2'

# Usage
client = YahooFinance::Client.new
stock = client.quote(@ticker)
```

**Data to Cache:**
```ruby
{
  ticker: "AAPL",
  price: 175.50,
  market_cap: 2_800_000_000_000,
  pe_ratio: 28.5,
  earnings_growth: 0.12,
  revenue: 394_000_000_000,
  net_income: 97_000_000_000,
  debt: 120_000_000_000,
  equity: 65_000_000_000,
  roic: 0.42,
  gross_margin: 0.44,
  # ... more metrics
}
```

**Caching Strategy:**
```ruby
Rails.cache.fetch("stock_data/#{ticker}/#{Date.current}", expires_in: 30.minutes) do
  fetch_from_yfinance
end
```

### 2. Claude API (AI Analysis)

**Configuration:**
```ruby
# config/initializers/anthropic.rb
ANTHROPIC_CONFIG = {
  api_key: ENV['ANTHROPIC_API_KEY'],
  model: 'claude-sonnet-4-20250514',
  max_tokens: 4096,
  temperature: 0.3 # Lower for more consistent analysis
}.freeze
```

**Service Implementation:**
```ruby
class ClaudeService < BaseService
  def analyze(investor:, stock_data:, question:)
    # Build system prompt with framework enforcement
    system_prompt = investor.system_prompt_with_framework

    # Build user message with stock data
    user_message = build_analysis_prompt(stock_data, question)

    # Call Claude API with web search enabled
    response = call_claude_api(
      system: system_prompt,
      messages: [{ role: 'user', content: user_message }],
      tools: [{ type: 'web_search' }]
    )

    # Parse and structure response
    success(parse_response(response))
  end

  private

  def call_claude_api(params)
    HTTP.post('https://api.anthropic.com/v1/messages',
      headers: anthropic_headers,
      json: params.merge(ANTHROPIC_CONFIG)
    )
  end

  def build_analysis_prompt(stock_data, question)
    <<~PROMPT
      Analyze #{stock_data[:ticker]} using your investment framework.

      Stock Data:
      #{format_stock_data(stock_data)}

      User Question: #{question}

      REQUIREMENTS:
      1. Apply your framework's quantitative criteria
      2. Show all calculations explicitly
      3. Search the web for recent news/events
      4. Provide recommendation with reasoning
      5. Be specific, not generic
    PROMPT
  end
end
```

**Caching AI Responses:**
```ruby
# Cache key includes investor, ticker, and question hash
cache_key = [
  "analysis",
  investor.id,
  stock_data[:ticker],
  Digest::MD5.hexdigest(question)
].join("/")

Rails.cache.fetch(cache_key, expires_in: 1.hour) do
  # Expensive AI call
end
```

### 3. Web Search (via Claude)

Claude API has built-in web search when you pass the tool:

```ruby
{
  tools: [{ type: 'web_search' }]
}
```

Claude automatically decides when to search based on the query.

---

## 💰 Monetization (Stripe Integration)

### User Tiers

```ruby
# app/models/user.rb
enum tier: { free: 0, pro: 1, enterprise: 2 }

def daily_analysis_limit
  case tier
  when 'free' then 10
  when 'pro' then Float::INFINITY
  when 'enterprise' then Float::INFINITY
  end
end

def can_analyze?
  analyses.where('created_at > ?', 24.hours.ago).count < daily_analysis_limit
end

def max_concurrent_investors
  case tier
  when 'free' then 2
  when 'pro' then 5
  when 'enterprise' then Float::INFINITY
  end
end
```

### Stripe Setup (Simple)

```ruby
# Gemfile
gem 'stripe'

# config/initializers/stripe.rb
Stripe.api_key = ENV['STRIPE_SECRET_KEY']

# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
  def create
    session = Stripe::Checkout::Session.create(
      customer_email: current_user.email,
      payment_method_types: ['card'],
      line_items: [{
        price: ENV['STRIPE_PRO_PRICE_ID'], # Create in Stripe dashboard
        quantity: 1
      }],
      mode: 'subscription',
      success_url: dashboard_url,
      cancel_url: pricing_url
    )

    redirect_to session.url, allow_other_host: true
  end
end

# Webhook handler for subscription events
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET'])

    case event.type
    when 'checkout.session.completed'
      handle_successful_payment(event.data.object)
    when 'customer.subscription.deleted'
      handle_subscription_cancelled(event.data.object)
    end

    head :ok
  end
end
```

### Rate Limiting

```ruby
# Gemfile
gem 'rack-attack'

# config/initializers/rack_attack.rb
Rack::Attack.throttle('analyses/ip', limit: 100, period: 1.day) do |req|
  req.ip if req.path == '/analyses' && req.post?
end

Rack::Attack.throttle('analyses/user', limit: 1000, period: 1.day) do |req|
  req.env['warden'].user&.id if req.path == '/analyses' && req.post?
end
```

---

## 🎨 Frontend (Hotwire + Tailwind)

### Investor Selection (Turbo Frames)

```erb
<!-- app/views/analyses/new.html.erb -->
<%= turbo_frame_tag "investor_selector" do %>
  <div class="flex gap-3 mb-6">
    <% @investors.each do |investor| %>
      <%= render InvestorAvatarComponent.new(
        investor: investor,
        selected: @selected_investors.include?(investor.id)
      ) %>
    <% end %>
  </div>
<% end %>
```

### Chat Interface (Turbo Streams)

```ruby
# app/views/analyses/create.turbo_stream.erb
<%= turbo_stream.append "messages" do %>
  <%= render partial: "analyses/user_message", locals: { analysis: @analysis } %>
<% end %>

<%= turbo_stream.append "messages" do %>
  <%= render partial: "analyses/loading_message" %>
<% end %>
```

### Real-time Updates (Action Cable)

```ruby
# app/jobs/analysis_job.rb
def broadcast_completion(analysis)
  Turbo::StreamsChannel.broadcast_replace_to(
    "analysis_#{analysis.id}",
    target: "analysis_#{analysis.id}",
    partial: "analyses/completed",
    locals: { analysis: analysis }
  )
end
```

---

## 🧪 Testing Strategy

### RSpec Setup

```ruby
# Gemfile (test group)
gem 'rspec-rails'
gem 'factory_bot_rails'
gem 'faker'
gem 'shoulda-matchers'
gem 'vcr' # Record HTTP interactions
gem 'webmock'

# spec/rails_helper.rb
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Database cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end
```

### Test Coverage Priority

**Day 1 (Core Logic):**
- Service objects (stock data, frameworks)
- Model validations
- Framework calculations

**Day 2 (Integration):**
- Controller specs
- Feature specs (key user flows)
- Component specs

**Example Test:**
```ruby
# spec/services/frameworks/munger_framework_service_spec.rb
RSpec.describe Frameworks::MungerFrameworkService do
  describe '#call' do
    let(:stock_data) do
      {
        ticker: 'AAPL',
        debt_to_equity: 0.75,
        roic: 0.08,
        pe_ratio: 30,
        # ...
      }
    end

    subject(:result) { described_class.call(stock_data) }

    it 'triggers high leverage kill switch' do
      expect(result.data[:kill_switches_triggered]).to include(
        hash_including(switch: :high_leverage)
      )
    end

    it 'triggers low ROIC kill switch' do
      expect(result.data[:kill_switches_triggered]).to include(
        hash_including(switch: :low_roic)
      )
    end

    it 'recommends rejection' do
      expect(result.data[:recommendation]).to start_with('PASS')
    end
  end
end
```

---

## 🚀 Deployment (Railway)

### Setup Steps

1. **Create Railway Project**
   ```bash
   railway login
   railway init
   ```

2. **Add Services**
   - PostgreSQL (auto-provisioned)
   - Redis (add from catalog)
   - Rails app (auto-detected)

3. **Environment Variables**
   ```
   ANTHROPIC_API_KEY=your_key_here
   STRIPE_SECRET_KEY=your_key_here
   STRIPE_PUBLISHABLE_KEY=your_key_here
   STRIPE_WEBHOOK_SECRET=your_key_here
   RAILS_MASTER_KEY=from_config/master.key
   ```

4. **Custom Domain (Optional)**
   - Add in Railway dashboard
   - Free SSL included

### Railway Configuration

```toml
# railway.toml
[build]
builder = "NIXPACKS"

[deploy]
healthcheckPath = "/up"
healthcheckTimeout = 100
restartPolicyType = "ON_FAILURE"
```

### Database Setup

```bash
# On first deploy
railway run rails db:create db:migrate db:seed
```

### Monitoring

Railway provides:
- Deploy logs
- Runtime logs
- Metrics (CPU, memory, requests)
- Alerts

---

## 📋 Build Checklist (48 Hours)

### Day 1 - Foundation (12 hours)

**Morning (4 hours):**
- [x] Create project structure
- [ ] Initialize Rails 7 with PostgreSQL
- [ ] Set up Tailwind CSS
- [ ] Install core gems (devise, stimulus, turbo)
- [ ] Create database schema and migrations
- [ ] Set up RSpec + FactoryBot

**Afternoon (4 hours):**
- [ ] Build User model + Devise authentication
- [ ] Build Investor model + seed data
- [ ] Build Stock model with caching
- [ ] Build Analysis model
- [ ] StockDataService (yfinance integration)
- [ ] Write tests for services

**Evening (4 hours):**
- [ ] ClaudeService (AI integration)
- [ ] Munger framework service (kill switches)
- [ ] Buffett framework service (DCF)
- [ ] Basic UI layout (nav, footer)
- [ ] Investor selection component

### Day 2 - Features (12 hours)

**Morning (4 hours):**
- [ ] Lynch framework service
- [ ] Graham framework service
- [ ] Dalio framework service
- [ ] Chat interface (Turbo Streams)
- [ ] Analysis controller + views

**Afternoon (4 hours):**
- [ ] Background jobs (AnalysisJob)
- [ ] Real-time updates (Action Cable)
- [ ] Charts integration (Chart.js)
- [ ] Portfolio model + controller
- [ ] Rate limiting (Rack Attack)

**Evening (4 hours):**
- [ ] Stripe integration (basic)
- [ ] Pricing page
- [ ] Landing page
- [ ] Polish UI
- [ ] Deploy to Railway
- [ ] Write comprehensive README

### Post-48h (Polish)
- [ ] Comprehensive tests
- [ ] Error handling improvements
- [ ] Performance optimization
- [ ] Analytics (Plausible/Fathom)
- [ ] SEO optimization

---

## 🎯 Success Criteria

**For Zipline Application:**
- ✅ Live demo deployed on Railway
- ✅ GitHub repo with clean code
- ✅ Comprehensive README
- ✅ Real investor frameworks implemented
- ✅ Multi-investor analysis working
- ✅ Clean architecture (Service Objects, ViewComponents)
- ✅ Tests for core logic
- ✅ Production concerns (caching, rate limiting, error handling)

**For Real Product:**
- ✅ User authentication
- ✅ Stripe integration
- ✅ Freemium model
- ✅ Open source
- ✅ Analytics
- ✅ Landing page with marketing copy

---

## 📚 Key Resources

**Rails Best Practices:**
- https://guides.rubyonrails.org/
- https://www.rubystyle.guide/
- https://thoughtbot.com/blog (best practices)

**Hotwire:**
- https://hotwired.dev/
- https://turbo.hotwired.dev/handbook/introduction

**ViewComponent:**
- https://viewcomponent.org/

**Testing:**
- https://rspec.info/
- https://thoughtbot.com/blog/how-we-test-rails-applications

**Deployment:**
- https://docs.railway.app/

---

## 🚨 Important Notes

1. **Code Quality Over Features**
   - Better to ship 80% with perfect code than 100% with messy code
   - Every file should be a teaching example
   - Comment complex logic
   - Write tests for core business logic

2. **Framework Accuracy**
   - Use ACTUAL investor methodologies
   - Show calculations explicitly
   - Reference sources in comments
   - Don't fake the math

3. **Performance**
   - Cache aggressively (stock data, AI responses)
   - Use background jobs for AI calls
   - Optimize database queries (includes, eager loading)
   - Monitor N+1 queries (bullet gem)

4. **Security**
   - Never commit API keys
   - Use strong_parameters
   - Sanitize user input
   - Rate limit API endpoints

5. **Git Commits**
   - Commit frequently
   - Descriptive messages
   - Atomic commits (one concern per commit)
   - No "WIP" commits in main

---

## 💡 Using This Plan

**In a fresh Claude Code chat:**

1. Open this directory: `/home/arn/projects/value-vault`
2. Share PLAN.md
3. Say: "Build Value Vault following PLAN.md. Start with Day 1 checklist."
4. Work incrementally, testing as you go
5. Commit after each completed feature
6. Deploy early, iterate

**Key Principle:**
Build in small, tested increments. Don't write 1000 lines then test. Write 50 lines, test, commit, repeat.

---

**Ready to build something exceptional!** 🚀

---

## 🔮 Future Strategy (Post-Job)

### Open Source + Hosted Model

Once job is secured and project validated with Enrica/Zipline team, consider:

**Open Source (Self-Hosted):**
- MIT License
- Full source code on GitHub
- Documentation for self-hosting
- Users provide their own Anthropic API key
- Free for individuals and companies to run
- Community contributions welcome

**Hosted Version (SaaS):**
- Managed hosting on Railway/Heroku
- No API key required - included in subscription
- Tier pricing:
  - **Free**: 10 analyses/day, single investor
  - **Pro** ($29/month): Unlimited analyses, all investors, portfolio features
  - **Team** ($99/month): Multiple users, shared portfolios, API access
- Revenue share with contributors
- Professional support

**Why This Model:**
1. **Accessibility**: Anyone can self-host for free
2. **Convenience**: Pay for managed hosting + no API setup
3. **Community**: Open source builds trust and contributions
4. **Revenue**: Hosted version generates income while keeping code open
5. **Portfolio**: Demonstrates both technical + business thinking

**Examples of this model working:**
- Ghost (blogging platform)
- Plausible Analytics
- Cal.com
- Supabase
- Discourse

**Timeline:**
- **Now**: Focus on getting hired (priority #1)
- **After job secured**: Deploy hosted version, write launch post
- **Month 1-3**: Gather feedback, iterate, gauge interest
- **Month 3-6**: Decide if worth scaling or keeping as side project

**Key Principle:**
Job first. Everything else is optional. This project already served its purpose (demonstrate skills). Anything beyond that is bonus.
