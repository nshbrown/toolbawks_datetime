# The Calendar Helper methods create HTML code for different variants of the
# Dynarch DHTML/JavaScript Calendar.
#
# Author: Michael Schuerig, <a href="mailto:michael@schuerig.de">michael@schuerig.de</a>, 2005
# Free for all uses. No warranty or anything. Comments welcome.
#
# Version 0.02:
# Always set calendar_options's ifFormat value to '%Y/%m/%d %H:%M:%S'
# so that the calendar recieves the object's time of day.  Previously,
# the '%c' formating used to set the initial date would be parsed by
# the JavaScript calendar correctly to find the date, but it would not
# pick up the time of day.
#
# Version 0.01:
# Original version by Michael Schuerig.
#

#
#
# == Prerequisites
#
# Get the latest version of the calendar package from
# <a href="http://www.dynarch.com/projects/calendar/">http://www.dynarch.com/projects/calendar/</a>
#
# == Installation
#
# You need to install at least these files from the jscalendar distribution
# in the +public+ directory of your project
#
#  public/
#      images/
#          calendar.gif [copied from img.gif]
#      javascripts/
#          calendar.js
#          calendar-setup.js
#          calendar-en.js
#      stylesheets/
#          calendar-system.css
#
# Then, in the head section of your page templates, possibly in a layout,
# include the necessary files like this:
#
#  <%= stylesheet_link_tag 'calendar-system.css' %>
#  <%= javascript_include_tag 'calendar', 'calendar-en', 'calendar-setup' %>
#
# == Common Options
#
# The +html_options+ argument is passed through mostly verbatim to the
# +text_field+, +hidden_field+, and +image_tag+ helpers.
# The +title+ attributes are handled specially, +field_title+ and
# +button_title+ appear only on the respective elements as +title+.
#
# The +calendar_options+ argument accepts all the options of the
# JavaScript +Calendar.setup+ method defined in +calendar-setup.js+.
# The ifFormat option for +Calendar.setup+ is set up with a default
# value that sets the calendar's date and time to the object's value,
# so only set it if you need to send less specific times to the
# calendar, such as not setting the number of seconds.

#
#

# Enrico Teotti -- agenteo@gmail.com
# I needed a way to get rid of the difference between my local data
# (d/m/y) and the one stored in the DB.
# So I was trying to get the calendar popup to return the DB value in to
# a hidden textbox and a visual value to a displayArea but
# popup_calendar didn't do the latter. (1)
# I've found that the calendar-setup.js you're using is different from
# the one I've downloaded from dynarc, using the new one I got my thing
# working but not the select_calendar.
#
# <%= form_tag({:action => 'inserisci_commento'},{:name =>
# 'inserisci_commento'}) %>
# <span id="vis_data"></span><!-- the user will see the data here -->
# <%= popup_calendar 'person', 'birthday',
#      { :class => 'date',
# 				:form_name => 'inserisci_commento',
#        :field_title => 'Birthday',
#        :button_image => 'calendar.gif',
#        :button_title => 'Show calendar' },
#      { :firstDay => 1,
# 				:displayArea => 'vis_data',
# 				:showsTime => false,
# 				:daFormat => '%d/%m/%Y',
#        :range => [1920, 1990],
#        :step => 1,
#        :showOthers => true,
#        :cache => true }
# %>
# 	<%= submit_tag "vota!", :class => 'button' %>
# <%= end_form_tag %>

module CalendarHelper

  # Returns HTML code for a calendar that pops up when the calendar image is
  # clicked.
  #
  # _Example:_
  #
  #  <%= popup_calendar 'person', 'birthday',
  #        { :class => 'date',
  #          :field_title => 'Birthday',
  #          :button_image => 'calendar.gif',
  #          :button_title => 'Show calendar' },
  #        { :firstDay => 1,
  #          :range => [1920, 1990],
  #          :step => 1,
  #          :showOthers => true,
  #          :cache => true }
  #  %>
  #
  def popup_calendar(object, method, html_options = {}, calendar_options = {})
    calendar_tag(object, method, :popup, html_options, calendar_options)
  end

  # Returns HTML code for a flat calendar.
  #
  # _Example:_
  #
  #  <%= calendar 'person', 'birthday',
  #        { :class => 'date' },
  #        { :firstDay => 1,
  #          :range => [1920, 1990],
  #          :step => 1,
  #          :showOthers => true }
  #  %>
  #
  def calendar(object, method, html_options = {}, calendar_options = {})
    calendar_options[:popup] ||= false
    calendar_tag(object, method, :flat, html_options, calendar_options)
  end

  # Returns HTML code for a date field and calendar that pops up when the
  # calendar image is clicked.
  #
  # _Example:_
  #
  #  <%= calendar_field 'person', 'birthday',
  #        { :class => 'date',
  #          :date => value,
  #          :field_title => 'Birthday',
  #          :button_title => 'Show calendar' },
  #        { :firstDay => 1,
  #          :range => [1920, 1990],
  #          :step => 1,
  #          :showOthers => true,
  #          :cache => true }
  #  %>
  #
  def calendar_field(object, method, html_options = {}, calendar_options = {})
    calendar_tag(object, method, :field, html_options, calendar_options)
  end
  def calendar_box(object, method, html_options = {}, calendar_options = {})
    calendar_tag(object, method, :box, html_options, calendar_options)
  end

  # Returns HTML code for a date field and calendar that pops up when the
  # calendar image is clicked.
  #
  # _Example:_
  #
  #  <%= calendar_select 'person', 'birthday',
  #        { :class => 'date',
  #          :date => value,
  #          :field_title => 'Birthday',
  #          :button_title => 'Show calendar' },
  #        { :firstDay => 1,
  #          :range => [1920, 1990],
  #          :step => 1,
  #          :showOthers => true,
  #          :cache => true }
  #  %>
  #
  def calendar_select(object, method, html_options = {}, calendar_options = {})
    calendar_tag(object, method, :select, html_options, calendar_options)
  end

  private

  def calendar_tag(object, method, show_field, html_options = {}, calendar_options = {})
    button_image = html_options[:button_image] || 'calendar.gif'
    date = value(object, method)
    show_field ||= :box
    calendar_options[:popup] ||= true

    input_field_name = "#{object}[#{method}]" 
    input_field_id = "#{object}_#{method}" 
    calendar_id = "#{object}_#{method}_calendar" 
    help_id = "#{object}_#{method}_help"
    if show_field == :select
      input_field_year_id = "#{object}[#{method}(1i)]" 
      input_field_month_id = "#{object}[#{method}(2i)]" 
      input_field_day_id = "#{object}[#{method}(3i)]" 
    end
    
    add_defaults(calendar_options, :ifFormat => '%Y/%m/%d %H:%M:%S')

    if calendar_options[:popup]
      cal_button_options = html_options.dup
      add_mandatories(cal_button_options, 
              :alt => 'Calendar',
              :id => calendar_id,
              :style => "cursor: pointer;")
      rename_option(cal_button_options, :button_title, :title)
      remove_option(cal_button_options, :field_title)
      cal_button_options[:engine] ||= 'dhtml_calendar'
      calendar = engine_image_tag(button_image, cal_button_options)
    else
      calendar = "<div id=\"#{calendar_id}\" class=\"#{html_options[:class]}\"></div>" 
    end

    field_options = html_options.dup
    add_defaults(field_options,
      :value => date && date.strftime(calendar_options[:ifFormat]),
      :size => 12
    )
    rename_option(field_options, :field_title, :title)
    remove_option(field_options, :button_title)
    case show_field
    when :select
      #TODO 2006-08-17 Level=1 - set year range dynamically
      calendar_options[:range] ||= [2000, 2020]
      field_options[:start_year] = calendar_options[:range][0]
      field_options[:end_year] = calendar_options[:range][1]
      field = date_select(object, method, field_options)
    when :field
      field = text_field(object, method, field_options)
    when :box
      help_button_options = {}
      add_mandatories(help_button_options, 
              :alt => 'Help',
              :id => help_id,
              :style => "cursor: pointer;",
              :title => "Show Help",
              :engine => 'dhtml_calendar')
      field = 
        content_tag("div",
	        (content_tag("ul",
    	      content_tag("li", 
    	        text_field(object, method,
    	          field_options.merge(
    	            :onChange => "magicDate('#{input_field_id}');", 
    	            :onKeyPress => "magicDateOnlyOnSubmit('#{input_field_id}', event); return dateBocksKeyListener(event);", 
    	            :onClick => "this.select();")
    	        )
    	      ) +
 	          content_tag("li", calendar) +
 	          content_tag("li", engine_image_tag('help.gif', help_button_options))
          ) + 
          content_tag("div", 
            content_tag("div", "", :id => "#{input_field_id}Msg"), :id => "dateBocksMessage", :class => "dateBocksMessage")
          ), :class => "dateBocks")
    else
      field = hidden_field(object, method, field_options)
    end

    calendar_setup = calendar_options.dup
    add_mandatories(calendar_setup,
      :formName => html_options[:form_name],
      :inputField => input_field_id,
      (calendar_options[:popup] ? :button : :flat) => calendar_id
    )
    case show_field
    when :box
      add_mandatories(calendar_setup,
        :ifFormat => :calendarIfFormat,
        :align => "Br",
        :help => help_id,
        :singleClick => true)
    when :select
      add_mandatories(calendar_setup,
        :inputFieldDay => input_field_day_id,
        :inputFieldMonth => input_field_month_id,
        :inputFieldYear => input_field_year_id
      )
    end
    case show_field
    when :box
<<END
#{field}
<script type="text/javascript">
  document.getElementById('#{input_field_id}Msg').innerHTML = calendarFormatString;
  Calendar.setup({ #{format_js_hash(calendar_setup)} });
</script>
END
    else
<<END
#{field}
#{calendar}
<script type="text/javascript">
  Calendar.setup({ #{format_js_hash(calendar_setup)} });
</script>
END
    end
  end

  def value(object_name, method_name)
    if object = self.instance_variable_get("@#{object_name}")
      object.send(method_name)
    else
      nil
    end
  end

  def add_mandatories(options, mandatories)
    options.merge!(mandatories)
  end

  def add_defaults(options, defaults)
    options.merge!(defaults) { |key, old_val, new_val| old_val }
  end

  def remove_option(options, key)
    options.delete(key)
  end

  def rename_option(options, old_key, new_key)
    if options.has_key?(old_key)
      options[new_key] = options.delete(old_key)
    end
    options
  end

  def format_js_hash(options)
    options.collect { |key,value| key.to_s + ':' + value.inspect.gsub(":","") }.join(',')
  end

end