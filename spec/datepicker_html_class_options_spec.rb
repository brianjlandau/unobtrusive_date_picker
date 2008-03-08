require File.dirname(__FILE__) + '/spec_helper'

describe "all date picker form helpers", :shared => true do
   include ActionView::Helpers::TagHelper
   include ActionView::Helpers::FormTagHelper
   include ActionView::Helpers::FormHelper
   include ActionView::Helpers::DateHelper
   include ActionView::Helpers::ActiveRecordHelper
   include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper
   
   before(:each) do
      @date = Date.parse("March 15, 2007")
      @date_model = stub('DateModel', :date => @date, :id => 1)
   end
   
   after(:each) do
      @date, @date_model = nil
   end
end


describe UnobtrusiveDatePicker, "with a :highlight_days passed a string" do
   it_should_behave_like "all date picker form helpers"
   
   before(:each) do
      @days = '123'
      @datepicker_html = unobtrusive_date_picker(:date_model, :date, {:highlight_days => @days})
   end
   
   it "should have the correct class" do
      year_id = 'date_model_date'
      year_name = 'date_model[date(1i)]'
      highlight_days = 'highlight-days-' + @days
      
      @datepicker_html.should include_tag(:select, :attributes => {:id => year_id, :name => year_name, :class => "#{highlight_days} split-date"})
   end
   
   after(:each) do
      @datepicker_html = nil
   end
   
end
