#!/usr/bin/expect -f
#!/bin/sh
# Copyright (C) 2008  Antoine Mercadal
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

set localPort [lrange $argv 0 0]
set remoteHost [lrange $argv 1 1]
set remotePort [lrange $argv 2 2]
set username [lrange $argv 3 3]
set tunnelHost [lrange $argv 4 4]
set password [lrange $argv 5 5 ]
set serverPort [lrange $argv 6 6 ]

spawn ssh -N -L$localPort:$remoteHost:$remotePort $username@$tunnelHost -p $serverPort  -R *:$localPort:host:hostport
match_max 100000

set timeout 1
#expect  "*yes/no*" {send "yes\r"; exp_continue};

set timeout -1
expect {
		"?sh: Error*" {puts "CONNECTION_ERROR"; exit};
		"*yes/no*" {send "yes\r"; exp_continue};
		"*Connection refused*" {puts "CONNECTION_REFUSED"; exit};
		"*?assword:*" {	send "$password\r"; set timeout 4;
						expect "*?assword:*" {puts "WRONG_PASSWORD"; exit;}
					  };
}

puts "CONNECTED";
set timeout -1
expect eof;

