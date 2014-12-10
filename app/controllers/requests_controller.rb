class RequestsController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  def user_requests
    if params[:client_id].blank?
      render json: {:status => false, :message => "Please provide the ID."}
    else
      begin
          @client = Client.find(params[:client_id])
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
    if params[:id].blank?
      render json: {:status => false, :message => "Please provide the request_id"}
    else
      begin
        @request = Request.find(params[:id])
        @request.update_attribute("rqst_status", true)
      
      rescue Exception => e
       end
      
    end
  end
  
  def rejected
    @request = Request.find(params[:id])
    @request.destroy
  end
  
end
