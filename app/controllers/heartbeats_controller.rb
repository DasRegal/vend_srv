class HeartbeatsController < ApplicationController
  before_action :set_heartbeat, only: %i[ show update destroy ]

  # GET /heartbeats
  def index
    @heartbeats = Heartbeat.all

    render json: @heartbeats
  end

  # GET /heartbeats/1
  def show
    render json: @heartbeat
  end

  # POST /heartbeats
  def create
    @heartbeat = Heartbeat.new(heartbeat_params)

    if @heartbeat.save
      render json: @heartbeat, status: :created, location: @heartbeat
    else
      render json: @heartbeat.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /heartbeats/1
  def update
    @heartbeat.touch(:last_seen_at)
    if @heartbeat.update(heartbeat_params)
      render json: @heartbeat
    else
      render json: @heartbeat.errors, status: :unprocessable_content
    end
  end

  # DELETE /heartbeats/1
  def destroy
    @heartbeat.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_heartbeat
      @heartbeat = Heartbeat.find_by(id: params[:id]) || Heartbeat.find_by!(serial_number: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def heartbeat_params
      params.fetch(:heartbeat).permit(:serial_number, :last_seen_at)
    end
end
