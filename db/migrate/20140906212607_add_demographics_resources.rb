class AddDemographicsResources < ActiveRecord::Migration
  def change

  	create_table :demographics_resources do |t|
    	t.belongs_to :demographic
      	t.belongs_to :resource
    end

  end
end
