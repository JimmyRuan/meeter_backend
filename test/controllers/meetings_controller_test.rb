require "test_helper"

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meeting = meetings(:one)
  end

  test "should get index" do
    get meetings_url, as: :json
    assert_response :success
  end

  test "should show meet" do
    get meeting_url(@meeting), as: :json
    assert_response :success
  end

  test "should create meet" do
    Meeting.destroy_all
    assert_difference('Meeting.count') do
      post meetings_url, params: { meeting: {
        calendar_id: @meeting.calendar_id,
        start_time: @meeting.start_time,
        end_time: @meeting.end_time,
        status: @meeting.status,
        title: @meeting.title,
        attendees_number: @meeting.attendees_number
      } }, as: :json
    end

    assert_response 201
  end

  test "a meeting's start_time must be before end_time" do
    start_time = Date.today.at_middle_of_day
    end_time = Date.today.at_beginning_of_day
    post meetings_url, params: { meeting: {
      calendar_id: @meeting.calendar_id,
      start_time: start_time,
      end_time: end_time,
      status: @meeting.status,
      title: @meeting.title,
      attendees_number: @meeting.attendees_number
    } }, as: :json

    assert_response 422
  end

  test "a meeting's start_time and end_time must be on the same day" do
    start_time = Date.today.at_middle_of_day
    end_time = Date.tomorrow.at_beginning_of_day
    post meetings_url, params: { meeting: {
      calendar_id: @meeting.calendar_id,
      start_time: start_time,
      end_time: end_time,
      status: @meeting.status,
      title: @meeting.title,
      attendees_number: @meeting.attendees_number
    } }, as: :json
    assert_response 422
  end

  test "a meeting cannot overlap with other meetings" do
    meetings(:one).save
    meetings(:two).save
    post meetings_url, params: { meeting: {
      calendar_id: @meeting.calendar_id,
      start_time: '2021-08-14 10:54:14',
      end_time: '2021-08-14 11:15:14',
      status: @meeting.status,
      title: @meeting.title,
      attendees_number: @meeting.attendees_number
    } }, as: :json
    assert_response 422
  end

  test "canceling a meeting with a provided reason" do
    @meeting.save
    cancel_reason = 'I am having lunch now'
    patch cancel_meeting_url(:id=>@meeting.id), params: { meeting: {
      :cancel_reason => cancel_reason
    }}

    updated_meeting = Meeting.find(@meeting.id)
    assert_response 201
    assert_equal(cancel_reason, updated_meeting.cancel_reason)
    assert_equal(Meeting::CANCEL_STATUS, updated_meeting.status)
  end

end
