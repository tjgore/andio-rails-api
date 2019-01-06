class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :update, :destroy]
  before_action :authenticate_request!, only: [:create, :update, :user_requests, :index, :destroy, :map_requests]

  # GET /requests/map_requests
  def map_requests
    @requests = Request.where(active: 1).where(status: 'not fullfilled').where.not(user_id: @current_user.id).where("(longitude <= :longone AND longitude >= :longtwo) AND (latitude <= :latone AND latitude >= :lattwo)", {longone: params[:request][:northEastLng], longtwo: params[:request][:southWestLng], latone: params[:request][:northEastLat], lattwo: params[:request][:southWestLat]}).order("created_at DESC").limit(20)
    @requests = request_user_fullname(@requests)

    render json: @requests
  end


  #GET /requests/count
  def count
    @requests = Request.where(status: 'not fullfilled').all()
    render json: { total: @requests.count }, status: :ok
  end

  # Get only logged in user request /user_requests
  def user_requests
    @requests = Request.where(user_id: @current_user.id).order("created_at DESC").limit(6)
    @requests = request_user_fullname(@requests)
    render json: @requests
  end


  # POST /requests
  def create
    #render json: @current_user.id
    @request = Request.new(request_params) 
    if @request.save
      render json: @request, status: :created, location: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # Update request status
  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      render json: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @request
  end

  # DELETE /requests/1
  def destroy
    if @request.destroy
      render json: { message: "Delete successful" }, status: :no_content
    else
      render json: { message: "Failed" }, status: :unprocessable_entity
    end
  end

  private

    def request_user_fullname (requests)
      user_ids = []
      @requests.each do |request|
        user_ids.push(request.user_id)
      end
      @requests = getUserFullName(user_ids, @requests)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def request_params
      params.require(:request).permit(:user_id, :title, :location, :latitude, :longitude, :description, :category, :status, :active, :start_count) 
    end
end
