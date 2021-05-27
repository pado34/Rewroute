class TestoJob < ActiveJob::Base
  def perform(*args)
    puts "hello"
  end
end
