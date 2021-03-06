
# I held the south hand given below, and east opened 2C.
# I overcalled 2S red-on-red.  This procedure deals hands
# where east will open 2C in front of the south hand.

south is "Q86432 T2 932 83"

main {
	set h [hcp east]
	reject if {$h<18} 
	accept if {$h>22} {[losers east]<4}
}	       
#
# Copyright (C) 1996-2001, Thomas Andrews
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#
