require 'bunny'
require 'kafka'

BROKER_TYPE = ENV['BROKER_TYPE'] || 'rabbitmq'

case BROKER_TYPE
when 'rabbitmq'
  BROKER_CONN = Bunny.new(ENV['RABBITMQ_URL'] || 'amqp://admin:Root2026@localhost:5672')
  BROKER_CONN.start
  BROKER_CHANNEL = BROKER_CONN.create_channel
when 'kafka'
  BROKER_CONN = Kafka.new(seed_brokers: [ENV['KAFKA_BROKER'] || 'localhost:9092'], client_id: 'otp_service')
else
  raise "BROKER_TYPE inconnu: #{BROKER_TYPE}"
end