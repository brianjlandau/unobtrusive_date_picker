require 'date'
require 'time'

module UnobtrusiveDatePicker

  # == Unobtrusive Date-Picker Helper
  # 
  # This Module helps to create date and date-time fields that use the 
  # Unobtrusive Date-Picker Javascript Widget.
  #
  # They also use the 12-hour AM/PM time format.
  #
  module UnobtrusiveDatePickerHelper

    DATEPICKER_DEFAULT_NAME_ID_SUFFIXES = { :year  => {:id => '',   :name => 'year'},
                                            :month => {:id => 'mm', :name => 'month'},
                                            :day   => {:id => 'dd', :name => 'day'} }

    DATEPICKER_DAYS_OF_WEEK = { :Monday     => '0',
                                :Tuesday    => '1',
                                :Wednesday  => '2',
                                :Thursday   => '3',
                                :Friday     => '4',
                                :Saturday   => '5',
                                :Sunday     => '6'}
    
    DATEPICKER_DIVIDERS = { 'slash' => '/',
                            'dash'  => '-',
                            'dot'   => '.',
                            'space' => ' ' }
    
    RANGE_DATE_FORMAT = '%Y-%m-%d'

    ##
    # Creates the date picker with the calendar widget.
    #
    def unobtrusive_date_picker(object_name, method, options = {}, html_options = {})
      ActionView::Helpers::InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_datepicker_date_select_tag(options, html_options)
    end

    ##
    # Creates the date-time picker with the calendar widget, and AM/PM select.
    #
    def unobtrusive_datetime_picker(object_name, method, options = {}, html_options = {})
      ActionView::Helpers::InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_datepicker_datetime_select_tag(options, html_options)
    end
    
    ##
    # Creates the date picker with the calendar widget.
    #
    def unobtrusive_date_text_picker(object_name, method, options = {}, html_options = {})
      ActionView::Helpers::InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_datepicker_text_tag(options, html_options)
    end

    ##
    # Creates the date picker with the calendar widget without a model object.
    #
    def unobtrusive_date_picker_tags(date = Date.today, options = {}, html_options = {})
      options[:prefix] = html_options.delete(:id)
      options[:order] ||= []
      [:year, :month, :day].each { |o| options[:order].push(o) unless options[:order].include?(o) }

      date_picker = ''
      options[:order].each do |o|
        date_picker << self.send("datepicker_select_#{o}", date, options, html_options)
      end
      date_picker
    end

    ##
    # Creates the date-time picker with the calendar widget, and AM/PM select without a model object
    #
    def unobtrusive_datetime_picker_tags(datetime = Time.now, options = {}, html_options = {})
      options[:prefix] = html_options.delete(:id)
      separator = options[:datetime_separator] || ''

      datetime_picker = unobtrusive_date_picker_tags(datetime, options, html_options) + separator

      datetime_picker << datepicker_select_hour(datetime, options, html_options) + ':'
      datetime_picker << datepicker_select_minute(datetime, options, html_options) + ' '
      datetime_picker << datepicker_select_ampm(datetime, options, html_options)

      datetime_picker
    end
    
    ##
    # Creates the text field based date picker with the calendar widget without a model object.
    #
    def unobtrusive_date_text_picker_tag(name, date = Date.today, options = {}, html_options = {})
      options, html_options = datepicker_text_field_options(options, html_options)
      value = format_date_value_for_text_field(options[:format], options[:divider], date)
      text_field_tag(name, value, html_options)
    end

    def datepicker_select_ampm(datetime, options = {}, html_options = {})
      ampm = %w(AM PM)
      val = datetime ? (ampm.include?(datetime) ? datetime : datetime.strftime("%p")) : ''

      ampm_options = []
      ampm.each { |meridiem| 
        ampm_options << ((val == meridiem) ? 
          %(<option value="#{meridiem}" selected="selected">#{meridiem}</option>\n) :
          %(<option value="#{meridiem}">#{meridiem}</option>\n)
        )
      }

      select_html(options[:field_name] || 'ampm', ampm_options, options, html_options)
    end

    def datepicker_select_hour(datetime, options = {}, html_options = {})
      val = datetime ? (datetime.kind_of?(Fixnum) ? datetime : datetime.strftime("%I").to_i) : ''

      hour_options = []
      1.upto(12) do |hour|
        hour_options << ((val == hour) ?
          %(<option value="#{hour}" selected="selected">#{hour}</option>\n) :
          %(<option value="#{hour}">#{hour}</option>\n)
        )
      end

      select_html(options[:field_name] || 'hour', hour_options, options, html_options)
    end

    ##
    # Can except a "<tt>minute_step</tt>" option which will specify how many minutes to move forward on each loop.
    #
    # i.e. if set to 15: 0, 15, 30, and 45 will be the options supplied in the minute select
    #
    def datepicker_select_minute(datetime, options = {}, html_options = {})
      val = datetime ? (datetime.kind_of?(Fixnum) ? datetime : datetime.strftime("%M").to_i) : ''

      minute_options = []
      0.step(59, options[:minute_step] || 1) do |minute|
        minute_options << ((val == minute) ?
          %(<option value="#{leading_zero_on_single_digits(minute)}" selected="selected">#{leading_zero_on_single_digits(minute)}</option>\n) :
          %(<option value="#{leading_zero_on_single_digits(minute)}">#{leading_zero_on_single_digits(minute)}</option>\n)
        )
      end

      select_html(options[:field_name] || 'minute', minute_options, options, html_options)
    end

    def datepicker_select_day(date, options = {}, html_options = {})
      val = date ? (date.kind_of?(Fixnum) ? date : date.day) : ''

      day_options = []
      1.upto(31) do |day|
        day_options << ((val == day) ?
          %(<option value="#{day}" selected="selected">#{day}</option>\n) :
          %(<option value="#{day}">#{day}</option>\n)
        )
      end

      datepicker_select_html(:day, day_options, options, html_options)
    end

    ##
    # This method will accept a hash for the option "<tt>use_month_names</tt>" where the key is the month number
    # and the value is the month name. It will also accept a boolean option "<tt>use_short_mont</tt>" that will
    # allow the use of short names instead of full names for the option text. Will also take "<tt>use_month_numbers</tt>", 
    # and "<tt>add_month_numbers</tt>" which use or add month numbers to the option item text.
    #
    def datepicker_select_month(date, options = {}, html_options = {})
      val = date ? (date.kind_of?(Fixnum) ? date : date.month) : ''

      month_options = []
      month_names = options[:use_month_names] || (options[:use_short_month] ? Date::ABBR_MONTHNAMES : Date::MONTHNAMES)
      month_names.unshift(nil) if month_names.size < 13
      1.upto(12) do |month_number|
        month_name = if options[:use_month_numbers]
          month_number
        elsif options[:add_month_numbers]
          month_number.to_s + ' - ' + month_names[month_number]
        else
          month_names[month_number]
        end

        month_options << ((val == month_number) ?
          %(<option value="#{month_number}" selected="selected">#{month_name}</option>\n) :
          %(<option value="#{month_number}">#{month_name}</option>\n)
        )
      end

      datepicker_select_html(:month, month_options, options, html_options)
    end

    ##
    # This method will accept a "<tt>start_year</tt>" and "<tt>end_year</tt>" options.
    #
    def datepicker_select_year(date, options = {}, html_options = {})
      val = date ? (date.kind_of?(Fixnum) ? date : date.year) : ''

      y = date ? (date.kind_of?(Fixnum) ? (date == 0 ? Date.today.year : date) : date.year) : Date.today.year
      start_year, end_year = (options[:start_year] || y-5), (options[:end_year] || y+5)
      step_val = start_year < end_year ? 1 : -1

      year_options = []
      start_year.step(end_year, step_val) do |year|
        year_options << ((val == year) ?
          %(<option value="#{year}" selected="selected">#{year}</option>\n) :
          %(<option value="#{year}">#{year}</option>\n)
        )
      end

      html_classes = make_date_picker_class_options(options).push('split-date')
      html_options[:class] = html_options[:class] ? "#{html_options[:class]} #{html_classes.join(' ')}" : html_classes.join(' ')
      datepicker_select_html(:year, year_options, options, html_options)
    end

    protected

    def datepicker_select_html(type, html_options, options, select_tag_options = {}) # :nodoc:
      datepicker_name_and_id(type, options)
      
      select_options = {:id => options[:id], :name => options[:name]}
      select_options.merge!(:disabled => 'disabled') if options[:disabled]
      select_options.merge!(select_tag_options) unless select_tag_options.empty?
      
      select_html = "\n"
      select_html << content_tag(:option, '', :value => '') + "\n" if options[:include_blank]
      select_html << html_options.to_s
      content_tag(:select, select_html, select_options) + "\n"
    end

    def datepicker_name_and_id(type, html_options) # :nodoc:
      if html_options[:id_prefix]
        html_options[:id] = (type == :year) ? "#{html_options[:id_prefix]}" : "#{html_options[:id_prefix]}-#{DATEPICKER_DEFAULT_NAME_ID_SUFFIXES[type][:id]}"
      else
        html_options[:prefix] ||= ActionView::Helpers::DateHelper::DEFAULT_PREFIX
        html_options[:id] = ((type == :year) ? 
          html_options[:prefix] : 
          html_options[:prefix] + "-#{DATEPICKER_DEFAULT_NAME_ID_SUFFIXES[type][:id]}"
        )
        html_options[:name] = html_options[:prefix] + "[#{DATEPICKER_DEFAULT_NAME_ID_SUFFIXES[type][:name]}]"
      end
    end
    
    def datepicker_text_field_options(options, html_options)
      defaults = {:format => 'm-d-y', :divider => 'slash'}
      options = defaults.merge(options)
      html_classes = make_date_picker_class_options(options)
      html_options[:class] = html_options[:class] ? "#{html_options[:class]} #{html_classes.join(' ')}" : html_classes.join(' ')
      [options, html_options]
    end
    
    def format_date_value_for_text_field(format, divider_option, value)
      divider = DATEPICKER_DIVIDERS[parse_divider_option(divider_option)]
      format_string = format.downcase.gsub(/(m|d)/, '%\1').gsub(/y/, '%Y').gsub('-', divider)
      value.strftime(format_string)
    end

    def make_date_picker_class_options(options = {}) # :nodoc:
      html_classes = []

      if options[:highlight_days]
        highlight_days = parse_days_of_week(options[:highlight_days])
        if !highlight_days.blank?
          html_classes << "highlight-days-#{highlight_days}"
        end
      end

      if options[:range_low]
        range_low = parse_range_option(options[:range_low], 'low')
        if !range_low.blank?
          html_classes << range_low
        end
      end

      if options[:range_high]
        range_high = parse_range_option(options[:range_high], 'high')
        if !range_high.blank?
          html_classes << range_high
        end
      end

      if options[:disable_days]
        disable_days = parse_days_of_week(options[:disable_days])
        if !disable_days.blank?
          html_classes << "disable-days-#{disable_days}"
        end
      end

      if options[:no_transparency]
        html_classes << 'no-transparency'
      end
      
      if options[:format] && %W(d-m-y m-d-y y-m-d).include?(options[:format].downcase)
        html_classes << "format-#{options[:format].downcase}"
      end
      
      if options[:divider]
        html_classes << "divider-#{parse_divider_option(options[:divider])}"
      end

      html_classes
    end

    def parse_days_of_week(option) # :nodoc:
      if option.is_a? String
        option
      elsif option.is_a? Symbol
        DATEPICKER_DAYS_OF_WEEK[option]
      elsif option.is_a? Array
        days = ''
        option.each do |day|
          days << DATEPICKER_DAYS_OF_WEEK[day]
        end
        days
      end
    end

    def parse_range_option(option, direction) # :nodoc:
      if option.is_a? Symbol
        case option
        when :today
          range_class = 'today'
        when :tomorrow
          range_class = Date.tomorrow.strftime(RANGE_DATE_FORMAT)
        when :yesterday
          range_class = Date.yesterday.strftime(RANGE_DATE_FORMAT)
        end
      elsif option.is_a? String
        if !option.blank?
          range_class = Date.parse(option).strftime(RANGE_DATE_FORMAT)
        else
          range_class = nil
        end
      elsif (option.is_a?(Date) || option.is_a?(DateTime) || option.is_a?(Time))
        range_class = option.strftime(RANGE_DATE_FORMAT)
      else
        range_class = nil
      end

      if !range_class.blank?
        range_class = 'range-' + direction + '-' + range_class
      else
        nil
      end
    end
    
    def parse_divider_option(option)
      if DATEPICKER_DIVIDERS.keys.include?(option)
        option
      else
        DATEPICKER_DIVIDERS.find {|name, value| option == value}.first
      end
    end

  end

  module AssetTagHelper
    ##
    # This will add the necessary <link> and <script> tags to include the necessary stylesheet and
    # javascripts.
    #
    def unobtrusive_datepicker_includes(options = {})
      output = []
      output << javascript_include_tag('datepicker', options)
      output << stylesheet_link_tag('datepicker', options)
      output * "\n"
    end
  end

  module InstanceTag # :nodoc: all
    include UnobtrusiveDatePicker::UnobtrusiveDatePickerHelper

    def to_datepicker_datetime_select_tag(options = {}, html_options = {})
      datepicker_select(options, true, html_options)
    end

    def to_datepicker_date_select_tag(options = {}, html_options = {})
      datepicker_select(options, false, html_options)
    end
    
    def to_datepicker_text_tag(options = {}, html_options = {})
      options, html_options = datepicker_text_field_options(options, html_options)
      html_options[:value] = format_date_value_for_text_field(options[:format], options[:divider], value(object))
      to_input_field_tag('text', html_options)
    end

    private

    def datepicker_select(options, time, html_options = {})
      defaults = { :discard_type => true }
      options  = defaults.merge(options)

      datetime = value(object)
      datetime ||= Time.now unless options[:include_blank]

      position = { :year => 1, :month => 2, :day => 3, :hour => 4, :minute => 5, :ampm => 6 }
      order    = (options[:order] ||= [:day, :month, :year])

      # Maintain valid dates by including hidden fields for discarded elements
      [:day, :month, :year].each { |o| order.unshift(o) unless order.include?(o) }

      # Ensure proper ordering of :hour, :minute and :second
      if time
        [:hour, :minute, :ampm].each { |o| order.delete(o); order.push(o) }
      end

      date_or_time_select = ''
      order.reverse.each do |param|
        if param == :ampm
          date_or_time_select.insert(0, self.send("datepicker_select_#{param}", datetime, datepicker_options_with_prefix(position[param], options.merge(:string => true)), html_options))
        else
          date_or_time_select.insert(0, self.send("datepicker_select_#{param}", datetime, datepicker_options_with_prefix(position[param], options), html_options))
        end
        date_or_time_select.insert(0,
          case param
          when :hour then " &nbsp; "
          when :minute then " : "
          else ""
          end
        )
      end

      date_or_time_select
    end

    def datepicker_options_with_prefix(position, options)
      prefix = "#{@object_name}"
      if options[:index]
        prefix << "[#{options[:index]}]"
      elsif @auto_index
        prefix << "[#{@auto_index}]"
      end
      options[:id_prefix] = "#{@object_name}_#{@method_name}"
      if options[:string]
        options[:name] = "#{prefix}[#{@method_name}(#{position}s)]"
        options.merge(:prefix => "#{prefix}[#{@method_name}(#{position}s)]")
      else
        options[:name] = "#{prefix}[#{@method_name}(#{position}i)]"
        options.merge(:prefix => "#{prefix}[#{@method_name}(#{position}i)]")
      end
    end

  end

end
# /UnobtrusiveDatePicker

module ActionView::Helpers::PrototypeHelper # :nodoc: all
  class JavaScriptGenerator
    module GeneratorMethods
      def unobtrusive_date_picker_create(id = nil)
        if id
          call "datePickerController.create", "$(#{id})"
        else
          record "datePickerController.create"
        end
      end
    end
  end
end


module ActionView # :nodoc: all
  module Helpers
    class FormBuilder
      def unobtrusive_date_picker(method, options = {}, html_options = {})
        @template.unobtrusive_date_picker(@object_name, method, options.merge(:object => @object), html_options)
      end
      
      def unobtrusive_date_text_picker(method, options = {}, html_options = {})
        @template.unobtrusive_date_text_picker(@object_name, method, options.merge(:object => @object), html_options)
      end

      def unobtrusive_datetime_picker(method, options = {}, html_options = {})
        @template.unobtrusive_datetime_picker(@object_name, method, options.merge(:object => @object), html_options)
      end
    end
  end
end

