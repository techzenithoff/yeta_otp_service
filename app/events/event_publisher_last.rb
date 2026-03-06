class EventPublisherLast
    MAX_RETRIES = 3
    RETRY_INTERVAL = 2

    REQUIRED_KEYS = %w[identifier channel context otp_code ].freeze

    def self.publish(topic, payload)

        payload = payload.deep_stringify_keys

        puts "PALOAD IN EVENT PUBLISHER: #{payload.inspect}"
        validate_payload!(payload)

        Rails.logger.info("Publishing event to #{topic} via #{BROKER_TYPE}: #{payload}")

        retries = 0

        begin
            case BROKER_TYPE
            when 'rabbitmq'

                puts "PUBLISHED IN RABBITMQ"
                queue = BROKER_CHANNEL.queue(topic, durable: true)
                queue.publish(payload.to_json, persistent: true)

            when 'kafka'
                puts "PUBLISHED IN KAFKA"
                BROKER_CONN.deliver_message(payload.to_json, topic: topic)

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