class ResourceEvent < ActiveRecord::Base

  include IceCube

	validates :resource_id, presence: true
	validates :schedule, presence: true
  # note that these times include a date but should be ignored.
	validates :start_time, presence: true
  validates :end_time, presence: true

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