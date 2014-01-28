class AddNeedStageToNeed < ActiveRecord::Migration
  def change
  	add_column :needs, :need_stage, :integer
  	add_index :needs, :need_stage
  end
end