class EventPublisherOld
    def self.publish(topic, payload)
        # Exemple RabbitMQ
        connection = Bunny.new(ENV["RABBITMQ_URL"])
        connection.start
        channel = connection.create_channel
        queue = channel.queue(topic, durable: true)
        queue.publish(payload.to_json, persistent: true)
        connection.close
    end
end