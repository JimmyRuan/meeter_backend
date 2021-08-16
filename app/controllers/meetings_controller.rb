class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :cancel]

  def index
    @meetings = Meeting.order(start_time: :desc).all

    render json: @meetings
  end

  def show
    render json: @meeting
  end

  def create
    @meeting = Meeting.new(meeting_params)
    if @meeting.save
      render json: @meeting, status: :created, location: @meeting
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  def cancel
    @meeting.cancel_reason = meeting_cancel_params
    if @meeting.save
      render json: @meeting, status: :created, location: @meeting
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meeting_params
      params.require(:meeting).permit(
        :calendar_id,
        :start_time,
        :end_time,
        # :status,
        :title,
        :attendees_number,
        :agenda
      )
    end

  def meeting_cancel_params
    params.require(:meeting).require(:cancel_reason)
  end
end
