class PagesController < ApplicationController
    include Concerns::String::SqlFilters
    
    before_action :authorize_page

    def show
<<<<<<< HEAD
        params[:resources].each do |key, value|
            value_to_set = destructive_transaction?(value) ? nil : eval(value)
            instance_variable_set( "@#{key}", policy_scope(value_to_set) ) unless value_to_set.nil?
        end unless(params[:resources].nil?)

=======
        authorize :page
        params[:resources].each { |key, value| instance_variable_set("@#{key}", is_invalid?(value) ? nil : eval(value)) } unless params[:resources].nil?
>>>>>>> staging
        render template: "pages/#{params[:page]}"
    end
    
    private

<<<<<<< HEAD
        def authorize_page
            authorize :page
        end
=======
        #returns true if input string does not follow pattern of: Modelname or Modelname.find/where/order/limit
        #note: the where query is currently limited to only single hash conditions
        def is_invalid? (value)
            value !~ /(?:\A[A-Z][a-z]+)(?:(\.)?(?(1)(?:(?:limit|find|order|wher)\(\w*:?\s?:?'?\w*'?\))))*$/
        end

>>>>>>> staging
end