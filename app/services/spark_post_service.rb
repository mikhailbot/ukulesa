require 'simple_spark'

class SparkPostService
  def initialize()
    @simple_spark = SimpleSpark::Client.new
  end

  def send_daily_notification(options)
    @simple_spark.transmissions.create(options)
  end
end
