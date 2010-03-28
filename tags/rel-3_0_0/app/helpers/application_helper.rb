module ApplicationHelper
  #include CalendarHelper
  
  # options
  # 
  #    prop. name               | description
  #  -------------------------------------------------------------------------------------------------
  #   help                      | show the help icon
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
    def model_value(object_name, method)
      object = instance_variable_get("@#{object_name.to_s}")
      value = object.send(method.to_s) unless object.nil? || !object.respond_to?(method.to_s)
      (value) ? value : ''
    end
    
    def quote_options_for_javascript(options)
      quote_options = {}
      
      options.each_with_index do |array, index|
        value = array[1]
        
        if value.class == FalseClass || value.class == TrueClass
          new_value = value.to_s
        elsif array[1].class == String && array[1].include?('javascript:')
          new_value = value
        elsif array[1][0..1] == '"\''
          new_value = value
        elsif array[1][0..1] == "'\""
          new_value = value
        elsif array[1][0] == '"'
          new_value = "'" + value.to_s + "'"
        elsif array[1][0] == "'"
          new_value = '"' + value.to_s + '"'
        else
          new_value = '"\'' + value.to_s + '\'"'
        end
        
        quote_options[array[0]] = new_value
      end
      
      quote_options
    end
    
    options.symbolize_keys!
    calendar_options.symbolize_keys!
    
    calendar_ref = 'DatetimeToolbocks' + object_name.to_s.capitalize + method.to_s.capitalize
    
    options[:elementId] = "#{calendar_ref}"
    options[:name] = (options[:name]) ? options[:name] : "#{object_name}[#{method}]"
    options[:value] = (options[:value]) ? options[:value] : model_value(object_name, method)
    
    valid_formats = ['dd/mm/yyyy',  'dd-mm-yyyy', 'mm/dd/yyyy', 'mm.dd.yyyy', 'yyyy-mm-dd', 'iso', 'de', 'us']
    options[:format] = (valid_formats.include?(options[:format])) ? options[:format] : "yyyy-mm-dd"
    
    calendar_options[:align] = "Br" if !calendar_options[:align] # alignment (defaults to "Br")
#    calendar_options[:showHelp] = (!options[:help].nil?) ? options[:help] : true
    
    <<-EOL
        <script type="text/javascript">
        new DatetimeToolbocks({ 
          elementId: '#{options[:elementId]}',
          inputName: '#{options[:name]}', 
          inputValue: '#{options[:value]}',
          showHelp: #{options[:help]},
          format: '#{options[:format]}',
          autoRollOver: #{options[:autoRollOver]},
          calendarOptions: #{options_for_javascript(quote_options_for_javascript(calendar_options))}
        });
        </script>

    EOL
  end
end