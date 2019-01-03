class ChatChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:id])
    stream_from "room-#{@room.id}"
  end

  def unsubscribed(data)
  end

  def join(data)
  	user = User.find_by(id: data["user_id"])

    user.current_room = @room.id
    user.status = "online"

    user.save

  	unless @room.users.include?(user)
    	@room.users << user
    	@room.save

      ActionCable.server.broadcast "room-#{@room.id}", type: "userJoin", user: user
    end

    ActionCable.server.broadcast "room-#{@room.id}", type: "presenceUpdate", status: "online", user: user.id
  end

  def leave(data)
    user = User.find_by(id: data["user_id"])

  	@room.users.delete(User.find_by(id: data["user_id"]))
  	@room.save

    user.current_room = nil
    user.status = "offline"

    user.save

  	ActionCable.server.broadcast "room-#{@room.id}", type: "userLeave", user: data["user_id"]
  end

  def exit(data)
    ActionCable.server.broadcast "room-#{@room.id}", type: "presenceUpdate", status: "offline", user: data["user_id"]
  end

  def message(data)
  	@message = Message.create(room_id: @room.id, user_id: data["user_id"], content: data["content"])

  	if @message.valid?
  		ActionCable.server.broadcast "room-#{@room.id}", type: "message", message: @message
  	end
  end

  def edit(data)
  	@message = Message.find(data["id"])

  	@message.update(content: data["content"])

  	ActionCable.server.broadcast "room-#{@room.id}", type: "messageEdit", content: @message.content, id: @message.id
  end

  def delete(data)
  	@message = Message.find(data["id"])

  	@message.destroy

  	ActionCable.server.broadcast "room-#{@room.id}", type: "messageDelete", id: data["id"]
  end
end
