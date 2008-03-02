require 'rubygems'
require 'active_support'
require 'action_controller'
require 'rexml/document'
require 'html/document'

module TagMatcher
   
   class IncludeTag
      def initialize(*expected)
         @expected = expected.size > 1 ? expected.last.merge({ :tag => expected.first.to_s }) : expected.first
      end
      
      def matches?(target)
         @target = HTML::Document.new(target)
         !@target.find(@expected).nil?
      end
      
      def failure_message
         "expected tag, but no tag found matching #{@expected.inspect} in #{@target.root.to_s}"
      end
      
      def negative_failure_message
         "expected no tag, but tag was found matching #{@expected.inspect} in #{@target.root.to_s}"
      end
   end
   
   def include_tag(*opts)
      IncludeTag.new(*opts)
   end
   
end
