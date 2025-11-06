# Value Vault 💎

> **AI-powered investment analysis with legendary investor personas**

Value Vault lets you analyze any stock through the lens of history's greatest investors: Charlie Munger, Warren Buffett, Peter Lynch, Benjamin Graham, and Ray Dalio. Each investor applies their actual, proven frameworks—not generic AI advice.

Built with **Rails 7.2.3**, **PostgreSQL**, **Tailwind CSS**, and **Claude Sonnet 4**.

---

## 📖 Context

**Built by:** [Arnaldo De Lisio](https://www.linkedin.com/in/arnaldo-de-lisio-5a1b68180/) (Financial Advisor + AI-native developer)
**Purpose:** Demonstrate Rails proficiency + domain expertise for job applications
**Status:** ✅ Demo-ready (November 2025)
**Timeline:** Built in focused sessions to showcase full-stack capabilities

This project combines:
- **10+ years** of formal business/finance education (Bachelor's degree + Financial Advisor certification)
- **2 years** of production software development (built SaaS serving 2,500 users)
- **Rails 7** best practices (service objects, MVC, Hotwire, migrations)
- **Real investor frameworks** (Munger's kill switches, Buffett's DCF, Lynch's GARP, etc.)

**Not just another AI wrapper** - this implements actual quantitative investment frameworks used by legendary investors.

---

## 🌟 Features

### 5 Legendary Investor Personas

Each investor uses their real-world frameworks with quantitative criteria:

- **Charlie Munger** - Kill switches & mental models from 4 disciplines
- **Warren Buffett** - Economic moat analysis & DCF valuation
- **Peter Lynch** - GARP (Growth at Reasonable Price) with PEG ratios
- **Benjamin Graham** - Pure quantitative value investing
- **Ray Dalio** - Economic machine & risk parity

### Real Stock Data

- Integrates with **yfinance** for comprehensive financial data
- 30-minute caching for performance
- Fetches: price, fundamentals, ratios, margins, growth metrics, cash flow

### AI-Powered Analysis

- Uses **Claude Sonnet 4** for nuanced, framework-driven analysis
- Web search integration for current market context
- Structured prompts ensure framework accuracy
- Shows all calculations explicitly

### Production-Ready

- User authentication with **Devise**
- Tier system (free/pro/enterprise) with daily limits
- PostgreSQL database with proper indexes
- Service object pattern for business logic
- Comprehensive error handling

---

## 🚀 Quick Start

### For Testing (Enrica & Zipline Team)

**Demo Account:**
- **Email**: `demo@valuevault.com`
- **Password**: `password123`
- **Limit**: 10 free analyses per day

**Try These Examples:**
1. **Ticker**: `AAPL` | **Investor**: Charlie Munger | **Question**: "Is Apple a good investment today?"
2. **Ticker**: `TSLA` | **Investor**: Warren Buffett | **Question**: "What's the intrinsic value of Tesla?"
3. **Ticker**: `NVDA` | **Investor**: Peter Lynch | **Question**: "Is NVIDIA still a growth stock?"

The analysis takes ~30 seconds (fetching stock data + AI analysis). All calculations are shown explicitly.

---

### For Local Development

**Prerequisites:**
- Ruby 3.2.3
- PostgreSQL
- Python 3.12+ (for yfinance)
- Node.js & npm (for Tailwind)

**Installation:**

```bash
# Clone repository
git clone https://github.com/yourusername/value-vault.git
cd value-vault

# Install dependencies
bundle install

# Set up Python environment
python3 -m venv venv
./venv/bin/pip install yfinance

# Create database and seed investors
rails db:create db:migrate db:seed

# Set up environment (required for AI analysis)
cp .env.example .env
# Add your ANTHROPIC_API_KEY to .env

# Start server
./bin/dev
```

Visit `http://localhost:3000` - demo account auto-created via seeds.

---

## 💡 Technical Highlights

**For Engineers Reviewing This Project:**

1. **Service Object Pattern**: Business logic extracted from controllers into reusable, testable services with consistent `Result` struct
   - `app/services/base_service.rb` - Parent class with success/failure pattern
   - `app/services/stock_data_service.rb` - Python subprocess integration with error handling
   - `app/services/claude_service.rb` - AI integration with structured prompts
   - `app/services/investor_analysis_service.rb` - Orchestration layer

2. **Python Integration**: Clean subprocess pattern for yfinance (no API limits, real-time data)
   - Virtual environment management
   - JSON serialization for data transfer
   - Error handling for missing tickers

3. **Hotwire Stack**: Modern Rails frontend without heavy JavaScript
   - Turbo for SPA-like navigation
   - Stimulus for interactive components (mobile menu, dropdown)
   - Responsive design (mobile hamburger menu)

4. **Database Design**: Proper normalization with intentional denormalization for caching
   - `Stock` model caches yfinance data (30-minute TTL)
   - `Analysis` stores full AI responses (no re-computation)
   - Investor frameworks in JSONB for flexibility

5. **Authentication & Authorization**: Devise with tier system
   - Daily usage limits per tier
   - Scoped queries (user sees only their analyses)
   - Future-ready for Stripe webhooks

6. **Real Investment Frameworks**: Not generic AI - actual quantitative criteria
   - Charlie Munger: 7 kill switches (hard rejection criteria)
   - Warren Buffett: DCF with owner earnings formula
   - Peter Lynch: PEG ratio categories
   - Benjamin Graham: Graham Number formula
   - Each framework mathematically defined in system prompts

---

## 🏗️ Architecture

### Service Objects

All business logic lives in service objects following a consistent pattern:

- `BaseService` - Parent class with `Result` struct
- `StockDataService` - Fetches and caches stock data from yfinance
- `ClaudeService` - Integrates with Claude API
- `InvestorAnalysisService` - Orchestrates full analysis flow

### Models

- `User` - Authentication, tier management, daily limits
- `Investor` - 5 investor personas with system prompts & framework configs
- `Stock` - Stock data caching with staleness checks
- `Analysis` - Analysis requests with status tracking
- `Portfolio` - User portfolios (future feature)

### Controllers

- `AnalysesController` - Main feature: create and view analyses
- `InvestorsController` - Browse investors and their frameworks

---

## 📊 Investor Frameworks

### Charlie Munger

**Kill Switches** (any one triggers rejection):
- Debt-to-Equity > 60%
- ROIC < 15%
- P/E > 25 (without exceptional moat)
- Declining gross margins
- No competitive advantage
- Cyclical business at peak

### Warren Buffett

**Process**:
1. Economic moat analysis (5 factors)
2. Owner earnings calculation
3. 10-year DCF with 9% discount rate
4. Margin of safety thresholds (30%+ for BUY)

### Peter Lynch

**Framework**:
- PEG ratio < 1.0 for undervalued stocks
- 6 company categories (fast growers, stalwarts, etc.)
- Growth quality checks (insider buying, debt levels)

### Benjamin Graham

**Criteria** (must pass ALL):
- P/E < 15
- P/B < 1.5
- P/E × P/B < 22.5
- Debt-to-Equity < 1.0
- Current Ratio > 2.0
- 10 years positive earnings
- No earnings decline > 5%

### Ray Dalio

**Focus**:
- 4 economic environments (goldilocks, overheating, deflation, stagflation)
- Risk parity portfolio construction
- Correlation analysis
- Position sizing by volatility

---

## 🧪 Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run with coverage
bundle exec rspec --format documentation
```

---

## 🔐 Environment Variables

Required:
- `ANTHROPIC_API_KEY` - Get from https://console.anthropic.com/

Optional:
- `STRIPE_SECRET_KEY` - For payment processing
- `STRIPE_PUBLISHABLE_KEY` - For Stripe checkout
- `STRIPE_WEBHOOK_SECRET` - For webhook verification
- `DATABASE_URL` - Custom database connection
- `REDIS_URL` - For caching and background jobs

---

## 📝 Tech Stack

**Backend:**
- Rails 7.2.3
- PostgreSQL
- Ruby 3.2.3
- Python (yfinance integration)

**Frontend:**
- Hotwire (Turbo + Stimulus)
- Tailwind CSS 4
- ViewComponents (future)

**AI & APIs:**
- Claude Sonnet 4 (Anthropic)
- yfinance (stock data)

**Testing:**
- RSpec
- FactoryBot
- Shoulda Matchers
- VCR & WebMock

---

## 🚢 Deployment

Ready for deployment on:
- Railway
- Heroku
- Render
- Any platform supporting Rails

See `PLAN.md` for detailed deployment instructions.

---

## 📚 Project Structure

```
value-vault/
├── app/
│   ├── controllers/     # AnalysesController, InvestorsController
│   ├── models/          # User, Investor, Stock, Analysis, Portfolio
│   ├── services/        # Business logic (StockDataService, ClaudeService)
│   ├── views/           # ERB templates with Tailwind
│   └── javascript/      # Stimulus controllers
├── db/
│   ├── migrate/         # Database migrations
│   └── seeds.rb         # Investor framework seeds
├── spec/                # RSpec tests
├── venv/                # Python virtual environment (gitignored)
└── PLAN.md              # Complete build plan & specifications
```

---

## 🎯 What's Next

### Current Status (November 2025)

**✅ Completed:**
- Core analysis feature (single ticker, investor selection, AI-powered responses)
- 5 investor personas with real frameworks
- User authentication with tier system
- Responsive UI with mobile navigation
- Stock data caching
- Markdown rendering
- Analysis history

**📋 Future Enhancements (If Validated):**
- [ ] Background jobs with Sidekiq (improve response time)
- [ ] Portfolio analysis (compare multiple stocks)
- [ ] Multi-investor comparison mode
- [ ] Historical tracking & analytics
- [ ] Stripe integration for tier upgrades
- [ ] PDF export
- [ ] Comprehensive test coverage
- [ ] Mobile app (React Native)

**Note:** This project is currently demo-ready. Future development depends on feedback and validation.

---

## 🌐 Future Strategy (Post-Job Secured)

### Open Source + Hosted Model

**Open Source (Self-Hosted):**
- MIT License on GitHub
- Users provide their own Anthropic API key
- Free for individuals and companies
- Community contributions welcome

**Hosted Version (SaaS):**
- Managed hosting on Railway/Heroku
- No API key required
- Tier pricing:
  - **Free**: 10 analyses/day, single investor
  - **Pro** ($29/month): Unlimited analyses, all investors, portfolio features
  - **Team** ($99/month): Multi-user, shared portfolios, API access

**Examples of this model:**
- Ghost (blogging)
- Plausible Analytics
- Cal.com
- Supabase

**Timeline:**
- **Now**: Focus on job search (priority #1)
- **After job secured**: Deploy hosted version, gather feedback
- **Month 1-3**: Validate market interest
- **Month 3-6**: Decide on scaling vs side project

---

## 📄 License

MIT License - Open source and available for self-hosting.

---

## 🙏 Acknowledgments

- **Charlie Munger, Warren Buffett, Peter Lynch, Benjamin Graham, Ray Dalio** - For the investment frameworks that power this tool
- **Anthropic** - Claude AI makes natural language analysis possible
- **Rails community** - For building an incredible framework

---

**Built by Arnaldo De Lisio** | [LinkedIn](https://www.linkedin.com/in/arnaldo-de-lisio-5a1b68180/) | [GitHub](https://github.com/yourusername)

*Bridging formal business education with AI-native development*
