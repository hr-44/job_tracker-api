module Seed
  @initial_users_count   = 5
  @initial_records_count = 30
  @initial_sources = %w(Other LinkedIn Glassdoor StackOverflow GitHub Dice
    Indeed AngelList Craigslist Hired SimplyHired Beyond HackerNews)
  @initial_categories = %w(Advertising Agency Automotive Communications
    Construction Education Finance Food Gaming Government Health Hospitality
    Industrial Insurance Legal Media Music Non-Profit Real-Estate Retail
    Search Security Science Software Transportation Web)
  @default_user = { first_name: 'Foo', last_name: 'Bar',
                    email: 'foobar@example.com' }
  @default_password = 'password'

  class << self
    # number of users (including yourself) to start out
    attr_accessor :initial_users_count
    # number of companies, contacts & notes to start out
    attr_accessor :initial_records_count
    attr_accessor :initial_sources
    attr_accessor :initial_categories
    attr_accessor :default_password
    attr_reader   :default_user
  end
end
