require 'rails_helper'

RSpec.describe Helpers::ResourceStateHelper, type: :helper do
  describe "testing the methods" do

    class Container
      include Helpers::ResourceStateHelper
      include AASM
      STATES = [:pending, :en_route, :in_progress, :pending_review, :completed, :problem, :deactivated]
    end

    let(:including_module) do
      Container.new
    end
    
    let(:valid_states) { including_module.class::STATES }
    let(:invalid_states) { [:this, :is, :not, :valid] }


    context "valid_state? method" do
      it "should return true if the passed state exists in the STATES array constant" do
        valid_states.map do |state|
          expect( including_module.valid_state?(state) ).to be_truthy
        end
      end

      it "should return false if the passed state does not exist in the STATES array constant" do
        invalid_states.map do |invalid_state|
          expect( including_module.valid_state?(invalid_state) ).to be_falsy
        end
      end
    end

    context "state_complete? method" do
      it "should return true if the state has been completed" do
        expect( including_module.state_completed?(:pending, :completed) ).to be_truthy
      end

      it "should return false if the state has not been completed" do
        expect( including_module.state_completed?(:completed, :pending) ).to be_falsy
      end
    end

    context "current_state? method" do
      it "should return true if the current_state matches the state passed to the method" do
        expect( including_module.current_state?(:pending, :pending) ).to be_truthy
      end

      it "should return false if the current_state does not match the state passed to the method" do
        expect( including_module.current_state?(:pending, :completed) ).to be_falsy
      end
    end

    context "interacting_with_state method" do
      it "should return true if the passed state matches the current state, or if it has been completed already" do
        expect( including_module.interacting_with_state?(:pending, :completed) ).to be_truthy
      end

      it "should return false if the passed state does not match the current state and it has not been completed" do
        expect( including_module.interacting_with_state?(:completed, :pending) ).to be_falsy
      end
    end

    context "set_state_user method" do
      before :each do
        @admin = FactoryGirl.create(:admin)
        including_module.set_state_user(@admin)
      end
      
      it "should set an instance variable with the type User" do
        expect( including_module.instance_variable_get('@user') ).to be_a(User)
        expect{ including_module.set_state_user(:invalid) }.to raise_error(ArgumentError)
      end
      
      it "should assign the instance variable to the user passed in" do
        expect( including_module.instance_variable_get('@user') ).to eq(@admin)
      end
    end
    
    context "valid_transition_with_previous_state? method" do
      it "should return true if the passed state exists in the STATES array constant" do
        valid_states.map do |state|
          state_index = valid_states.find_index(state)
          next_state = valid_states(state_index + 1)
          previous_state = valid_states(state_index - 1)
          previous_state_by_2 = valid_states(state_index - 2)

          expect( including_module.valid_transition_with_previous_state?(next_state, state) ).to be_truthy
          expect( including_module.valid_transition_with_previous_state?(next_state, previous_state) ).to be_truthy
          expect( including_module.valid_transition_with_previous_state?(previous_state, state) ).to be_truthy

          expect( including_module.valid_transition_with_previous_state?(next_state, previous_state_by_2) ).to be_falsy
        end
      end
      
    end

    # context "transitioning_to_problem_state method" do
    #   specify {
    #     expect( including_module.transitioning_to_problem_state?).to be_truthy
    #   }
    # end
  end
end
