require File.dirname(__FILE__) + '/spec_helper'
require 'erb'

describe "the date picker form builder helpers" do
   include ActionView::Helpers::TagHelper
   include ActionView::Helpers::TextHelper
   include ActionView::Helpers::UrlHelper
   include ActionView::Helpers::FormTagHelper
   include ActionView::Helpers::FormHelper
   include ActionView::Helpers::DateHelper
   include ActionView::Helpers::ActiveRecordHelper
   include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper
   
   before(:each) do
      @date = Date.parse("March 15, 2007")
      @date_model = stub('DateModel', :date => @date, :id => 1)
      
      @template = ERB.new <<-ERB
         <% form_for(:date_model, @date_model, :url => 'http://www.example.com/submit', :html => {:method => :get}) do |form| %>
            <%= form.unobtrusive_date_picker(:date) %>
         <% end %>
ERB
      @form = @template.result(binding)
   end
   
   it "should have the correct year select with class and select the correct year" do
      year_id = 'date_model_date'
      year_name = 'date_model[date(1i)]'
      
      @form.should include_tag(:select, :attributes => {:id => year_id, :name => year_name, :class => 'split-date'}, 
                                        :child => {:tag => 'option', 
                                                   :attributes => {:value => @date.year.to_s, :selected => 'selected'},
                                                   :content => @date.year.to_s})
   end
   
   it "should have the correct month select with class and select the correct month" do
      month_id = 'date_model_date-mm'
      month_name = 'date_model[date(2i)]'
      
      @form.should include_tag(:select, :attributes => {:id => month_id, :name => month_name}, 
                                        :child => {:tag => 'option', 
                                                   :attributes => {:value => @date.month.to_s, :selected => 'selected'},
                                                   :content =>  Date::MONTHNAMES[@date.month]})
   end
   
   it "should have the correct day select with class and select the correct day" do
      day_id = 'date_model_date-dd'
      day_name = 'date_model[date(3i)]'
      
      @form.should include_tag(:select, :attributes => {:id => day_id, :name => day_name}, 
                                        :child => {:tag => 'option', 
                                                   :attributes => {:value => @date.day.to_s, :selected => 'selected'},
                                                   :content =>  @date.day.to_s})
   end
   
   after(:each) do
      @date, @date_model, @form = nil
   end
   
end
