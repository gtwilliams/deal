#
# By agreement, you open a weak 2 with exactly 6 cards in your major,
# fewer than 4 cards in the other major, 5-10 HCP and either 2 of the
# top 3 or three of the top 5 in your suit.
#

defvector W2Q 2 2 2 1 1
main {
	set sh [hcp south]
	reject if {$sh>10} {$sh<5} {[clubs south]>3} {[diamonds south]>3}
	set s [spades south]
	if {$s == 6} {
		reject if {[hearts south]>3} {[W2Q south spades]<=3}
		accept
	}
	reject if {$s>3}
	set h [hearts south]
	reject if {$h!=6} {[W2Q south hearts]<=3}
	accept
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
