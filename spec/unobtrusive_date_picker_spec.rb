require File.dirname(__FILE__) + '/spec_helper'

describe "all date picker form helpers", :shared => true do
   include ActionView::Helpers::TagHelper
   include ActionView::Helpers::FormTagHelper
   include ActionView::Helpers::FormHelper
   include ActionView::Helpers::DateHelper
   include ActionView::Helpers::ActiveRecordHelper
   include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper
   
   before(:each) do
      @date_model = stub('DateModel', :date => Date.parse("March 15, 2007"), :id => 1)
      @datetime_model = stub('DateTimeModel', :datetime => Time.parse("March 15, 2007 2:37PM"), :id => 2)
      @new_datetime_model = stub('DateTimeModel', :datetime => nil, :id => nil)
      @new_date_model = stub('DateModel', :date => nil, :id => nil)
   end
   
   after(:each) do
      @date_model, @date_time_model, @new_datetime_model, @new_date_model = nil
   end
end

describe UnobtrusiveDatePicker, "with a stub ActiveRecord object" do
   it_should_behave_like "all date picker form helpers"
   
   it "should select the year from model object attribute" do
      datepicker_html = unobtrusive_date_picker(:date_model, :date)
      year_id = 'date_model_date'
      year_name = 'date_model[date(1i)]'
      
      datepicker_html.should include_tag(:select, :attributes => {:id => year_id, :name => year_name}, 
                                                  :child => {:tag => 'option', 
                                                             :attributes => {:value => '2007', :selected => 'selected'},
                                                             :content => '2007'})
   end
   
   it "should select the month from model object attribute" do
      datepicker_html = unobtrusive_date_picker(:date_model, :date)
      month_id = 'date_model_date-mm'
      month_name = 'date_model[date(2i)]'
      
      datepicker_html.should include_tag(:select, :attributes => {:id => month_id, :name => month_name}, 
                                                  :child => {:tag => 'option', 
                                                             :attributes => {:value => '3', :selected => 'selected'},
                                                             :content => 'March'})
   end
   
   it "should select the day from model object attribute" do
      datepicker_html = unobtrusive_date_picker(:date_model, :date)
      day_id = 'date_model_date-dd'
      day_name = 'date_model[date(3i)]'
      
      datepicker_html.should include_tag(:select, :attributes => {:id => day_id, :name => day_name}, 
                                                  :child => {:tag => 'option', 
                                                             :attributes => {:value => '15', :selected => 'selected'},
                                                             :content => '15'})
   end
   
end
