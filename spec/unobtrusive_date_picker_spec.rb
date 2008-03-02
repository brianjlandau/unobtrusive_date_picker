require File.dirname(__FILE__) + '/spec_helper'

describe UnobtrusiveDatePicker, "with no data passed to tag helper"  do
   include ActionView::Helpers::TagHelper
   include ActionView::Helpers::FormTagHelper
   include ActionView::Helpers::FormHelper
   include ActionView::Helpers::DateHelper
   include ActionView::Helpers::ActiveRecordHelper
   include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper
   
   before(:each) do
      @datepicker = unobtrusive_date_picker_tags(nil, {:include_blank => true})
   end
   
   it "should have default prefix for year id" do
      default_id = ActionView::Helpers::DateHelper::DEFAULT_PREFIX
      default_name = ActionView::Helpers::DateHelper::DEFAULT_PREFIX + "[#{UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper::DATEPICKER_DEFAULT_NAME_ID_SUFFIXES[:year][:name]}]"
      @datepicker.should include_tag(:select, :attributes => {:id => default_id, :name => default_name})
   end
   
   it "should have 'split-date' in class on year" do
      default_name = ActionView::Helpers::DateHelper::DEFAULT_PREFIX + "[#{UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper::DATEPICKER_DEFAULT_NAME_ID_SUFFIXES[:year][:name]}]"
      @datepicker.should include_tag(:select, :attributes => {:class => 'split-date', :name => default_name})
   end
   
   it "should have default prefix and 'mm' on month id" do
      default_id = ActionView::Helpers::DateHelper::DEFAULT_PREFIX + '-mm'
      default_name = ActionView::Helpers::DateHelper::DEFAULT_PREFIX + "[#{UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper::DATEPICKER_DEFAULT_NAME_ID_SUFFIXES[:month][:name]}]"
      @datepicker.should include_tag(:select, :attributes => {:id => default_id, :name => default_name})
   end
   
   it "should have default prefix and 'dd' on day id" do
      default_id = ActionView::Helpers::DateHelper::DEFAULT_PREFIX + '-dd'
      default_name = ActionView::Helpers::DateHelper::DEFAULT_PREFIX + "[#{UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper::DATEPICKER_DEFAULT_NAME_ID_SUFFIXES[:day][:name]}]"
      @datepicker.should include_tag(:select, :attributes => {:id => default_id, :name => default_name})
   end
   
   it "should include blank selected option for all selects" do
      ids = []
      ids << ActionView::Helpers::DateHelper::DEFAULT_PREFIX + '-dd'
      ids <<  ActionView::Helpers::DateHelper::DEFAULT_PREFIX + '-mm'
      ids << ActionView::Helpers::DateHelper::DEFAULT_PREFIX
      
      ids.each do |id|
         @datepicker.should include_tag(:select, :attributes => {:id => id}, :child => {:tag => 'option', :attributes => {:value => ''}, :content => ''})
      end
   end
   
   it "should use full month names for option text" do
      default_id = ActionView::Helpers::DateHelper::DEFAULT_PREFIX + '-mm'
      
      1.upto(12) do |month_number|
         @datepicker.should include_tag(:select, :attributes => {:id => default_id}, :child => {:tag => 'option', :attributes => {:value => month_number}, :content => Date::MONTHNAMES[month_number]})
      end
   end
   
   after(:each) do
      @datepicker = nil
   end
   
end



describe UnobtrusiveDatePicker, "with specific date and options passed to tag helpers"  do
   include ActionView::Helpers::TagHelper
   include ActionView::Helpers::FormTagHelper
   include ActionView::Helpers::FormHelper
   include ActionView::Helpers::DateHelper
   include ActionView::Helpers::ActiveRecordHelper
   include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper
   
   before(:each) do
      @date = Date.parse("March 15, 2007")
      @datepicker = unobtrusive_date_picker_tags(@date, {:include_blank => true})
   end
   
   after(:each) do
      @date = nil
      @datepicker = nil
   end
   
end



describe UnobtrusiveDatePicker, "with a stub ActiveRecord object"  do
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
   
   it "should select current date and time for new models" do
      pending
   end
   
   after(:each) do
      @date_model = nil
      @date_time_model = nil
      @new_datetime_model = nil
      @new_date_model = nil
   end
   
end
