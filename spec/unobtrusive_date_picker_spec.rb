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
   
   it "should select current date and time for new models" do
      pending
   end
   
end
