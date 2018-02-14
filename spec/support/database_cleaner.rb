RSpec.configure do |config|
  # truncation clean before all examples
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # transaction cleaning after each example
  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
