class AddPreviousStateToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :previous_state, :string
  end
end
