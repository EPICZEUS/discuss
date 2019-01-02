class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "list"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
