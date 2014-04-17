module SmsJob
  @queue = :high
  def self.perform
    sleep 5
    debugger
    puts 'abc'
  end
end
