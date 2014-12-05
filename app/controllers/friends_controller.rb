class FriendsController < ApplicationController
  def new
    
  end
  
  def create
    if params[:user][:id].blank?
      render json: {:status => false, :message => "Please fill the User ID"}
    elsif params[:user][:friend_name].blank?
      render json: {:status => false, :message => "Please fill the Friend Name"}
    elsif params[:user][:contact_number].blank?
      render json: {:status => false, :message => "Please fill the Contact Number"}
    else
      begin
         @client = Client.find(params[:user][:id])
       
         # Check Friends Count of User
         if @client.friends.count > 0
           render json: {:status => false, :message => "You have already add one friend. Purchase the number to add more friends"} 
         else  
           # Check Status of the User Details
           if  @client.status == true 
             @friend = @client.friends.create(friend_params)
               render json: {:status => true, "message" => "Friend has successfully added for the user", :friend_details => JSON.parse(@friend.to_json)}
           else 
             render json: {:status => false, :message => "The client of mentioned ID is not active."}
           end
         end    

      rescue Exception => e
        if @client.nil?
          render json: {:status => false, :message => "No User of this ID"}
         else
          render json: {:status => false, :message => "Something wrong has happened"}
         end
      end
    end
  end
  
  private
  
  def friend_params
    params.require(:user).permit(:friend_name, :contact_number)
  end
  
end
