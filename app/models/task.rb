class Task < ApplicationRecord
    include Concerns::Polymorphic::Helpers
    include Concerns::Notes::Notable
    include Helpers::ResourceStateHelper
    
    belongs_to :taskable, polymorphic: true

    validates :name, presence: true
    validate :note_added, if: lambda { transitioning_to_state?(:problem) }

    include AASM
    STATES = [:pending, :completed, :problem]
    aasm :column => 'resource_state', :with_klass => NorthwestTransferAASMBase do
        require_state_methods!

        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end

        event :complete do
            transitions to: :completed
        end

        event :report_problem, guards: :note_added? do
            transitions to: :problem
        end
    end

end