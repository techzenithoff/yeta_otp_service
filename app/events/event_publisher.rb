# app/events/event_publisher.rb
class EventPublisher
  MAX_RETRIES    = 3
  RETRY_INTERVAL = 2
  REQUIRED_KEYS  = %w[identifier channel context otp_code].freeze

  def self.publish(topic, payload)
    payload = payload.deep_stringify_keys
   
    validate_payload!(payload)

    Rails.logger.info("Publishing event to #{topic} via #{BROKER_TYPE}: #{payload}")

    retries = 0
    begin
      case BROKER_TYPE
      when 'rabbitmq'
        # Création/connexion à un exchange durable de type topic
        exchange = BROKER_CHANNEL.topic(topic, durable: true)
        Rails.logger.info("Exchange '#{topic}' ready on RabbitMQ")
        exchange.publish(payload.to_json, persistent: true)
        Rails.logger.info("OTP event published for #{payload['identifier']} via #{payload['channel']}")

      when 'kafka'
        BROKER_CONN.deliver_message(payload.to_json, topic: topic)
        Rails.logger.info("OTP event published to Kafka: #{payload}")

      else
        raise "BROKER_TYPE inconnu: #{BROKER_TYPE}"
      end

    rescue => e
      Rails.logger.error("Failed to publish event #{topic}: #{e.message}")
      retries += 1
      if retries <= MAX_RETRIES
        sleep(RETRY_INTERVAL)
        retry
      else
        Rails.logger.error("Event failed after #{MAX_RETRIES} retries: #{payload}")
      end
    end
  end

  def self.validate_payload!(payload)
    REQUIRED_KEYS.each do |key|
      raise "Payload missing key: #{key}" if payload[key].blank?
    end
  end
end