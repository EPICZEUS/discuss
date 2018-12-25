class ChatChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:id])
    stream_from "room-#{@room.id}"
  end

  def unsubscribed
  end

  def join(data)
  	user = User.find_by(id: data["user_id"])
  	return if @room.users.include?(user)
  	@room.users << user
  	@room.save

  	ActionCable.server.broadcast "room-#{@room.id}", {type: "userJoin", user: user}
  end

  def leave(data)
  	@room.users.delete(User.find_by(id: data["user_id"]))
  	@room.save

  	ActionCable.server.broadcast "room-#{@room.id}", {type: "userLeave", user: data["user_id"]}
  end

  def message(data)
  	@message = Message.create(room_id: @room.id, user_id: data["user_id"], content: data["content"])

  	if @message.valid?
  		ActionCable.server.broadcast "room-#{@room.id}", {type: "message", message: @message}
  	end
  end

  def edit(data)
  	@message = Message.find(data["id"])

  	@message.update(content: data["content"])

  	ActionCable.server.broadcast "room-#{@room.id}", {type: "messageEdit", content: @message.content, id: @message.id}
  end

  def delete(data)
  	@message = Message.find(data["id"])

  	@message.destroy

  	ActionCable.server.broadcast "room-#{@room.id}", {type: "messageDelete", id: data["id"]}
  end
end
