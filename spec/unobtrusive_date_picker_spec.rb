require File.dirname(__FILE__) + '/spec_helper'

describe "all date picker form helpers", :shared => true do
   include ActionView::Helpers::TagHelper
   include ActionView::Helpers::FormTagHelper
   include ActionView::Helpers::FormHelper
   include ActionView::Helpers::DateHelper
   include ActionView::Helpers::ActiveRecordHelper
   include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper
   
   before(:each) do
      @date, @time = Date.parse("March 15, 2007"), Time.parse("March 15, 2007 2:37PM")
      @date_model = stub('DateModel', :date => @date, :id => 1)
      @datetime_model = stub('DateTimeModel', :datetime => @time, :id => 2)
      @new_datetime_model = stub('DateTimeModel', :datetime => nil, :id => nil)
      @new_date_model = stub('DateModel', :date => nil, :id => nil)
   end
   
   after(:each) do
      @date, @time, @date_model, @date_time_model, @new_datetime_model, @new_date_model = nil
   end
end

describe UnobtrusiveDatePicker, "with a stub ActiveRecord object" do
   it_should_behave_like "all date picker form helpers"
   
   before(:each) do
      @datepicker_html = unobtrusive_date_picker(:date_model, :date)
   end
   
   it "should select the year from model object attribute" do
      year_id = 'date_model_date'
      year_name = 'date_model[date(1i)]'
      
      @datepicker_html.should include_tag(:select, :attributes => {:id => year_id, :name => year_name}, 
                                                   :child => {:tag => 'option', 
                                                              :attributes => {:value => @date.year.to_s, :selected => 'selected'},
                                                              :content => @date.year.to_s})
   end
   
   it "should select the month from model object attribute" do
      month_id = 'date_model_date-mm'
      month_name = 'date_model[date(2i)]'
      
      @datepicker_html.should include_tag(:select, :attributes => {:id => month_id, :name => month_name}, 
                                                   :child => {:tag => 'option', 
                                                              :attributes => {:value => @date.month.to_s, :selected => 'selected'},
                                                              :content => Date::MONTHNAMES[@date.month]})
   end
   
   it "should select the day from model object attribute" do
      day_id = 'date_model_date-dd'
      day_name = 'date_model[date(3i)]'
      
      @datepicker_html.should include_tag(:select, :attributes => {:id => day_id, :name => day_name}, 
                                                   :child => {:tag => 'option', 
                                                              :attributes => {:value => @date.day.to_s, :selected => 'selected'},
                                                              :content => @date.day.to_s})
   end
   
   after(:each) do
      @datepicker = nil
   end
   
end
