class FriendsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
    
  end
  
  def new_friend
    if params[:user][:id].blank?
      render json: {:status => false, :message => "Please fill the User ID"}
    elsif params[:user][:contact_number].blank?
      render json: {:status => false, :message => "Please fill the Contact Number"}
    else
      begin
         @client = Client.find(params[:user][:id])
         
          # Check Status of the User Details
          if @client.status == true 
             
             # Check Friends Count of User
               if @client.friend_credit == 0
                 render json: {:status => false, :message => "You have used your all credits. Purchase friend credits to add new friends."} 
               else  
                 
                 @friend = @client.friends.create(friend_params)
                 @client.update_attribute("friend_credit", @client.friend_credit - 1)
                   render json: {:status => true, "message" => "Friend has successfully added for the user", :friend_details => JSON.parse(@friend.to_json)}
               end
          else 
            render json: {:status => false, :message => "The client of mentioned ID is not active."}
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
