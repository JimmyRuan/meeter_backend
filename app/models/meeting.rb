class Meeting < ApplicationRecord
  validate :end_time_great_than_start_time
  validate :prevent_multiple_days_meeting
  validate :prevent_meeting_conflict

  private
  def end_time_great_than_start_time
    if start_time >= end_time
      self.errors.add :start_time, 'Start_time has to be before end_time'
    end
  end

  def prevent_multiple_days_meeting
    if start_time.to_date != end_time.to_date
      self.errors.add :end_time, 'The meeting cannot span multiple days.'
    end
  end

  def prevent_meeting_conflict
    meetings = Meeting.where.not(:id => id)
                      .where(:calendar_id => calendar_id)
                      .where(:start_time => start_time.beginning_of_day..start_time.end_of_day)

    meetings.each do |meeting|
      if (meeting.start_time <= start_time && meeting.end_time < start_time) ||
        (meeting.start_time < end_time && meeting.end_time >= end_time)
        self.errors.add :start_time, 'The meeting should not conflict (overlap) with other meetings.'
        break
      end
    end
  end
end
