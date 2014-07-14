class ResourceEvent < ActiveRecord::Base

  include IceCube

  # These are all on update only becasue of the issue listed here: http://stackoverflow.com/questions/16177919/rails-nested-form-for-column-cant-be-blank
	validates :resource_id, presence: true, on: :update
	validates :schedule, presence: true, on: :update
  # note that these times include a date but should be ignored.
	validates :start_time, presence: true, on: :update
  validates :end_time, presence: true, on: :update

	belongs_to :resource

  # # @return [IceCube::Schedule]
  def schedule_ice_cube
    if read_attribute(:schedule)
      Rule.from_yaml(read_attribute(:schedule))
    else
      nil
    end
  end

end