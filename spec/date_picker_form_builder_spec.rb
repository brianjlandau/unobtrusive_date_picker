require File.dirname(__FILE__) + '/spec_helper'
require 'erb'

describe "the date picker form builder helpers" do
   it_should_behave_like "all date picker helpers"
   
   before(:each) do
      @created = Date.parse("March 5, 2007")
      @updated = Date.parse("March 15, 2007")
      
      @date_model = stub('DateModel', :updated_at => @updated, :created_at => @created, :id => 1)
      
      @template = ERB.new <<-ERB
         <% form_for(:date_model, @date_model, :url => 'http://www.example.com/submit', :html => {:method => :get}) do |form| %>
            <%= form.unobtrusive_date_picker(:created_at) %>
            <%= form.unobtrusive_date_text_picker(:updated_at) %>
         <% end %>
ERB
      @form = @template.result(binding)
   end
   
   it "should have the correct year select with class and select the correct year" do
      year_id = 'date_model_created_at'
      year_name = 'date_model[created_at(1i)]'
      
      @form.should include_tag(:select, :attributes => {:id => year_id, :name => year_name, :class => 'split-date'}, 
                                        :child => {:tag => 'option', 
                                                   :attributes => {:value => @created.year.to_s, :selected => 'selected'},
                                                   :content => @created.year.to_s})
   end
   
   it "should have the correct month select with class and select the correct month" do
      month_id = 'date_model_created_at-mm'
      month_name = 'date_model[created_at(2i)]'
      
      @form.should include_tag(:select, :attributes => {:id => month_id, :name => month_name}, 
                                        :child => {:tag => 'option', 
                                                   :attributes => {:value => @created.month.to_s, :selected => 'selected'},
                                                   :content =>  Date::MONTHNAMES[@created.month]})
   end
   
   it "should have the correct day select with class and select the correct day" do
      day_id = 'date_model_created_at-dd'
      day_name = 'date_model[created_at(3i)]'
      
      @form.should include_tag(:select, :attributes => {:id => day_id, :name => day_name}, 
                                        :child => {:tag => 'option', 
                                                   :attributes => {:value => @created.day.to_s, :selected => 'selected'},
                                                   :content =>  @created.day.to_s})
   end
   
   it "should have a text field with the correct classes" do
     text_field_id = 'date_model_updated_at'
     
     @form.should selector_tag("input\##{text_field_id}.format-m-d-y.divider-slash[type='text'][value='03/15/2007']")
   end
   
   after(:each) do
      @date, @date_model, @form = nil
   end
   
end
