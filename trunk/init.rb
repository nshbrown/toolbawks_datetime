#  Copyright (c) 2006-2007 Nathaniel Brown
#  
#  GNU Lesser General Public License
#  Version 2.1, February 1999
#  
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#  
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#  
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#  


# load up all the required files we need...
require 'datetime_toolbocks'

DatetimeToolbocks.version = Proc.new { File.open(File.join(RAILS_ROOT, 'vendor', 'plugins', 'datetime_toolbocks', 'VERSION'), 'r').readlines[0] }

DatetimeToolbocks::DATE_FORMATS.each { |d| Date::DATE_FORMATS[d[0]] = d[1] }
