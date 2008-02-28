require File.dirname(__FILE__) + '/spec_helper'

describe UnobtrusiveDatePicker, "with a mock ActiveRecord object"  do
   
   before(:each) do
      include ActionView::Base
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormTagHelper
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::ActiveRecordHelper
      include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper
   end
   
   
   
   after(:each) do
      
   end
   
end
