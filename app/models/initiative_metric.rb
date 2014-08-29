class Datapoint
  include ActiveModel::Serializers::JSON

  attr_accessor :year, :periodName, :value

  # def attributes=(hash)
  #   hash.each do |key, value|
  #     send("#{key}=", value)
  #   end
  # end

  # def attributes
  #   instance_values
  # end
end



class InitiativeMetric < ActiveRecord::Base

	require 'rest_client'
	require 'json'

	belongs_to :initiative



	def get_data_for_this_metric
		response = RestClient.post "http://api.bls.gov/publicAPI/v1/timeseries/data/", { 'seriesid' => ['LAUMT213046000000003'], 'startyear' => '2013', 'endyear' => '2014' }.to_json, :content_type => :json, :accept => :json
		hash = JSON.parse response

    datapoints = Array.new
    datapoints_two = Array.new
    hash['Results']['series'][0]['data'].each do |stuff|
      Rails.logger.info stuff['period']
      datapoint = Datapoint.new
      datapoint.year = stuff['year']
      datapoint.periodName = stuff['periodName']
      datapoint.value = stuff['value']
      datapoints << datapoint
      datapoints_two << [DateTime.new(stuff['year'].to_i,self.get_month_int(stuff['periodName']),1).to_time.utc.to_i, stuff['value']]
    end
    response
    datapoints_two
	end



  def get_month_int(month_short)
    month_int = 0
    if month_short == 'January'
      month_int = 1
    elsif month_short == 'February'
      month_int = 2
    elsif month_short == 'March'
      month_int = 3
    elsif month_short == 'April'
      month_int = 4
    elsif month_short == 'May'
      month_int = 5
    elsif month_short == 'June'
      month_int = 6
    elsif month_short == 'July'
      month_int = 7
    elsif month_short == 'August'
      month_int = 8
    elsif month_short == 'September'
      month_int = 9
    elsif month_short == 'October'
      month_int = 10
    elsif month_short == 'November'
      month_int = 11
    elsif month_short == 'December'
      month_int = 12
    else
      month_int = 1
    end
  end




end
