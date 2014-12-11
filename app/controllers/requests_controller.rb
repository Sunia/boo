class RequestsController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  def user_requests
    if params[:client][:client_id].blank?
      render json: {:status => false, :message => "Please provide the ID."}
    else
      begin
          @client = Client.find(params[:client][:client_id])
          @requests = @client.requests
           render json: {:status => true, :request_details => JSON.parse(@requests.to_json) }
           
       rescue Exception => e
         if @client.nil?
          render json: {:status => false, :message => "No client of this ID"}
         else
           render json: {:status => false, :message => "Something wrong has happened."}
         end
       end
      
    end
  end

  
  
  def accepted
    if params[:request][:id].blank?
      render json: {:status => false, :message => "Please provide the request_id"}
    else
      begin
        # request accepted       
        @request = Request.find(params[:request][:id])
        @request.update_attribute("rqst_status", true)
        
       
        # Friend has added.
        client = 
        @friend = client.friends.create(friend_params)
       #client.update_attribute("friend_credit", @client.friend_credit - 1)
        #render json: {:status => true, "message" => "Friend has succesfully added", :friend_details => JSON.parse(@friend.to_json)}
        
        
        render json: {:status => true, :message => "Request has successfuly accepted."}
      rescue Exception => e
         if @request.nil?
           render json: {:status => false, :message => "No request of this ID."}
        else
          render json: {:status => false, :message => "Something went wrong"}
        end
      end
      
    end
  end
  
  def rejected
    if params[:request][:id].blank?
      render json: {:status => false, :message => "Please provide the request_id"}
    else
      begin
        @request = Request.find(params[:request][:id])
        @request.destroy
         render json: {:status => true, :message => "Request has successfuly rejected."}
      rescue Exception => e
         if @request.nil?
           render json: {:status => false, :message => "No request of this ID."}
        else
          render json: {:status => false, :message => "Something went wrong"}
        end
      end
      
    end
  end

  
end
