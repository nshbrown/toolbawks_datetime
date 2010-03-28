module ApplicationHelper
  #include CalendarHelper
  
  # options
  # 
  #    prop. name               | description
  #  -------------------------------------------------------------------------------------------------
  #   help                      | show the help icon
  #   showButton                | show the button icon (should be used in conjunction with the :flat param in the calendar options)
  #   format                    | the format to display the date (iso, de, us, dd/mm/yyyy, dd-mm-yyyy, mm/dd/yyyy, mm.dd.yyyy, yyyy-mm-dd)
  #   messageSpanSuffix         | default is 'Msg'
  #   messageSpanErrorClass     | default is 'error'
  #   messageSpanSuccessClass   | default is ''
  #   autoRollOver              | automatically roll over for days in a month. Ex 2/38/2000 will result in 3/09/2000

  # calendar_options
  # 
  # To use javascript code as a value, prefix with "javascript:"
  # 
  #    prop. name   | description
  #  -------------------------------------------------------------------------------------------------
  #   ifFormat      | IGNORED. Use the "format" property in the main object options.
  #   button        | IGNORED. Overriden in the javascript library.
  #   inputField    | IGNORED. Overriden in the javascript library.
  #   displayArea   | the ID of a DIV or other element to show the date
  #   eventName     | event that will trigger the calendar, without the "on" prefix (default: "click")
  #   daFormat      | the date format that will be used to display the date in displayArea
  #   singleClick   | (true/false) wether the calendar is in single click mode or not (default: true)
  #   firstDay      | numeric: 0 to 6.  "0" means display Sunday first, "1" means display Monday first, etc.
  #   align         | alignment (default: "Br"); if you don't know what's this see the calendar documentation
  #   range         | array with 2 elements.  Default: [1900, 2999] -- the range of years available
  #   weekNumbers   | (true/false) if it's true (default) the calendar will display week numbers
  #   flat          | null or element ID; if not null the calendar will be a flat calendar having the parent with the given ID
  #   flatCallback  | function that receives a JS Date object and returns an URL to point the browser to (for flat calendar)
  #   disableFunc   | function that receives a JS Date object and should return true if that date has to be disabled in the calendar
  #   onSelect      | function that gets called when a date is selected.  You don't _have_ to supply this (the default is generally okay)
  #   onClose       | function that gets called when the calendar is closed.  [default]
  #   onUpdate      | function that gets called after the date is updated in the input field.  Receives a reference to the calendar.
  #   date          | the date that the calendar will be initially displayed to
  #   showsTime     | default: false; if true the calendar will include a time selector
  #   timeFormat    | the time format; can be "12" or "24", default is "12"
  #   electric      | if true (default) then given fields/date areas are updated for each move; otherwise they're updated only on close
  #   step          | configures the step of the years in drop-down boxes; default: 2
  #   position      | configures the calendar absolute position; default: null
  #   cache         | if "true" (but default: "false") it will reuse the same calendar object, where possible
  #   showOthers    | if "true" (but default: "false") it will show days from other months too

  def toolbocks_date_select(object_name, method, options = {}, calendar_options = {})
    def model_value(object_name, method, format)
      object = instance_variable_get("@#{object_name.to_s}")
      value = object.send(method.to_s()) unless object.nil? || !object.respond_to?(method.to_s())
      value = value.strftime(DatetimeToolbocks::DATE_FORMATS[format]) if value.class == Date
      (value) ? value : nil
    end
    
    def quote_options_for_javascript(options)
      quote_options = {}
      
      options.each_with_index do |array, index|
        value = array[1]
        
        if value.class == FalseClass || value.class == TrueClass
          new_value = value.to_s
        elsif array[1].class == Fixnum || array[1].class == Float
          new_value = value.to_s
        elsif array[1].class == Array
          new_value = '[' + value.join(', ') + ']'
        elsif array[1].class == String && array[1].include?('javascript:')
          new_value = value.gsub('javascript:', '')
        else
          new_value = '"' + value.to_s + '"'
        end
        
        quote_options[array[0]] = new_value
      end
      
      quote_options
    end
    
    options.symbolize_keys!
    calendar_options.symbolize_keys!
    
    calendar_ref = 'DatetimeToolbocks' + object_name.to_s.classify + method.to_s.classify
    
    options[:elementId] = "#{calendar_ref}"
    options[:name] = (options[:name]) ? options[:name] : "#{object_name}[#{method}]"

    # Create formats before value so we can format properly

    options[:format] = (DatetimeToolbocks::DATE_FORMATS.include?(options[:format])) ? options[:format] : nil
    options[:value] = (options[:value]) ? options[:value] : model_value(object_name, method, options[:format])
    options[:showButton] = [true, false].include?(options[:showButton]) ? options[:showButton] : nil
    options[:autoRollOver] = [true, false].include?(options[:autoRollOver]) ? options[:autoRollOver] : nil

    options[:showHelp] = [true, false].include?(options[:showHelp]) || [true, false].include?(options[:help]) ? options[:showHelp] | options[:help] : nil  # take the combined value of the two params
    
    # if the user wants a flat calendar, but doesn't define whether they want it built or not, default to yes
    options[:buildFlat] = [true, false].include?(options[:buildFlat]) ? options[:buildFlat] : (calendar_options[:flat] ? true : nil)
        
    datetime_toolbocks_options = {
      :elementId => options[:elementId],
      :inputName => options[:name],
    }
    
    # options that are not required
    datetime_toolbocks_options_optional = {
      :format => options[:format],
      :inputValue => options[:value],
      :showHelp => options[:showHelp],
      :showButton => options[:showButton],
      :autoRollOver => options[:autoRollOver],
      :buildFlat => options[:buildFlat]
    }
    
    # only add the optional items that are not nil
    datetime_toolbocks_options_optional.each { |option| datetime_toolbocks_options[option[0]] = option[1] if !option[1].nil? }

    <<-EOL
      <div id="#{options[:elementId]}Container"></div>
      <script type="text/javascript">
      new DatetimeToolbocks({ 
        #{options_for_javascript(quote_options_for_javascript(datetime_toolbocks_options))[1..-2]},
        calendarOptions: #{options_for_javascript(quote_options_for_javascript(calendar_options))}
      });
      </script>
    EOL
  end
end
