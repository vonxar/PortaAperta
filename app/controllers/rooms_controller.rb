class RoomsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @rooms = Room.all.order(:id)
  end
  
   def new
     @user = User.find(params[:format])
    room = Room.create!
    room.first_user_id = current_user.id
    room.second_user_id = params[:format]
    retu = [@user.name,current_user.name]
    room.user_name = @user.name+" "+ "-----" +" "+current_user.name
    room.save
    redirect_to room_path(room)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
  end
  
end
