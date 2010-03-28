#  Copyright (c) 2006 Nathaniel Brown <nshb@inimit.com>
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

module DatetimeToolbocks
  mattr_accessor :version
  self.version = false
  
  DATE_FORMATS = {
    'dd/mm/yyyy' => "%d/%m/%Y", 
    'dd-mm-yyyy' => "%d-%m-%Y",
    'mm/dd/yyyy' => "%m/%d/%Y",
    'mm.dd.yyyy' => "%m.%d.%Y",
    'yyyy-mm-dd' => "%Y-%m-%d",
    'iso' => "%d/%m/%Y",
    'de' => "%m.%d.%Y",
    'us' => "%m/%d/%Y"
  }

  module ActionController

    def self.append_features(base)
      super
      base.extend(ClassMethods)
    end
	
    module ClassMethods
    end
	  
    protected

  end
end
