package ciscowlc;
##
## $Id: ciscowlc.pm.in 3444 2016-08-10 16:25:47Z heas $
##
## rancid 3.6.2
## Copyright (c) 1997-2016 by Henry Kilmer and John Heasley
## All rights reserved.
##
## This code is derived from software contributed to and maintained by
## Henry Kilmer, John Heasley, Andrew Partan,
## Pete Whiting, Austin Schutz, and Andrew Fort.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
## 1. Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
## 2. Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
## 3. All advertising materials mentioning features or use of this software
##    must display the following acknowledgement:
##        This product includes software developed by Henry Kilmer and John
##        Heasley and its contributors for RANCID.
## 4. Neither the name of RANCID nor the names of its
##    contributors may be used to endorse or promote products derived from
##    this software without specific prior written permission.
## 5. It is requested that non-binding fixes and modifications be contributed
##    back to RANCID.
##
## THIS SOFTWARE IS PROVIDED BY Henry Kilmer, John Heasley AND CONTRIBUTORS
## ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
## TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
## PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COMPANY OR CONTRIBUTORS
## BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
##
## It is the request of the authors, but not a condition of license, that
## parties packaging or redistributing RANCID NOT distribute altered versions
## of the etc/rancid.types.base file nor alter how this file is processed nor
## when in relation to etc/rancid.types.conf.  The goal of this is to help
## suppress our support costs.  If it becomes a problem, this could become a
## condition of license.
# 
#  The expect login scripts were based on Erik Sherk's gwtn, by permission.
# 
#  The original looking glass software was written by Ed Kern, provided by
#  permission and modified beyond recognition.
#
#  RANCID - Really Awesome New Cisco confIg Differ
#
#  ciscowlc.pm - Cisco WLC V4.X
#
#  based on modified version of ciscoips by Josh Yost on 4/16/2008
use 5.010;
use strict 'vars';
use warnings;
no warnings 'uninitialized';
require(Exporter);
our @ISA = qw(Exporter);

use rancid 3.6.2;

@ISA = qw(Exporter rancid main);
#XXX @Exporter::EXPORT = qw($VERSION @commandtable %commands @commands);

# load-time initialization
sub import {
    $timeo = 90;			# wlogin timeout in seconds
    0;
}

# post-open(collection file) initialization
sub init {
    # add content lines and separators
    ProcessHistory("","","","!RANCID-CONTENT-TYPE: $devtype\n!\n");

    0;
}

# main loop of input of device output
sub inloop {
    my($INPUT, $OUTPUT) = @_;
    my($cmd, $rval);

TOP: while(<$INPUT>) {
	tr/\015//d;
	if (/^.*logout(Connection.*closed.)?$/)  {
	    $clean_run = 1;
	    last;
	}
	if (/^Error:/) {
	    print STDOUT ("$host wlogin error: $_");
	    print STDERR ("$host wlogin error: $_") if ($debug);
	    $clean_run = 0;
	    last;
	}
	while (/($cmds_regexp)/) {
	    $cmd = $1;
	    if (!defined($prompt)) {
		$prompt = ($_ =~ /^([^#]+>)/)[0];
		$prompt =~ s/([][}{)(\\])/\\$1/g;
		print STDERR ("PROMPT MATCH: $prompt\n") if ($debug);
	    }
	    print STDERR ("HIT COMMAND:$_") if ($debug);
	    if (! defined($commands{$cmd})) {
		print STDERR "$host: found unexpected command - \"$cmd\"\n";
		$clean_run = 0;
		last TOP;
	    }
	    if (! defined(&{$commands{$cmd}})) {
		printf(STDERR "$host: undefined function - \"%s\"\n",  
		       $commands{$cmd});
		$clean_run = 0;
		last TOP;
	    }
	    $rval = &{$commands{$cmd}}($INPUT, $OUTPUT, $cmd);
	    delete($commands{$cmd});
	    if ($rval == -1) {
		$clean_run = 0;
		last TOP;
	    }
	}
    }
}

# This routine parses "show running-config"
sub ShowConfig {
    my($INPUT, $OUTPUT, $cmd) = @_;
    my($linecnt) = 0;
    print STDERR "    In ShowConfig: $_" if ($debug);
    ProcessHistory("","","","\n!--WLC Begin Config Data--!\n");

    while (<$INPUT>) {
        tr/\015//d;
        tr/\020//d;

	next if (/^\s*rogue ap classify/);
	next if (/^\s*rogue (adhoc|client) alert/);

	$linecnt++;

	# These can not be imported, so comment them
	if (/^\s*cisco public safety is not allowed to set in this domain/i ||
	    /^\s*outdoor mesh ext.unii b domain channels:/i ||
	    /^\s*service port.*/i ||
	    /^\s*wlan express setup.*/i ||
	    /^\s*wmm-ac (disabled|enabled)/i) {
	    ProcessHistory("","","","!$_"); next;
	}

        # remove snmp community string data
	if (/^(\s*snmp community create)/ && $filter_pwds >= 1) {
	    ProcessHistory("","","","!$1 <removed>\n"); next;
	}
	if (/^(\s*snmp community accessmode (ro|rw))/ && $filter_pwds >= 1) {
	    ProcessHistory("","","","!$1 <removed>\n"); next;
	}
	if (/^(\s*snmp community ipaddr\s\S+\s\S+) / && $filter_pwds >= 1) {
	    ProcessHistory("","","","!$1 <removed>\n"); next;
	}

	last if (/^$prompt/);
	next if (/^(\s*|\s*$cmd\s*)$/);

	$linecnt++;
	if (! /^$prompt/) {
	    print(STDERR "      ShowConfig Data: $_") if ($debug);
	    ProcessHistory("","","","$_");
	}
    }
    ProcessHistory("","","","\n!--WLC End Config Data--!\n");
    print STDERR "    Exiting ShowConfig: $_" if ($debug);
    # WLC lacks a definitive "end of config" marker.
    if ($linecnt > 5) {
	$found_end = 1;
	return(1);
    }
    return(0);
}

# This routine parses "show sysinfo"
sub ShowSysinfo {
    my($INPUT, $OUTPUT, $cmd) = @_;
    print STDERR "    In ShowSysinfo: $_" if ($debug);
    ProcessHistory("","","","\n!WLC Show Sysinfo Start\n!\n");

    while (<$INPUT>) {
	tr/\015//d;

	my($skipprocess) = 0;

	if (/^System Up Time/) { $skipprocess = 1; }
	if (/^fan status/i) { $skipprocess = 1; }
	if (/^Number of Active Clients/) { $skipprocess = 1; }
	if (/^OUI Classification Failure Count/) { $skipprocess = 1; }
	if (/^(internal|external) temperature/i) { $skipprocess=1; }
	if (/rpm$/) { $skipprocess = 1; }

	last if (/^$prompt/);
	next if (/^(\s*|\s*$cmd\s*)$/);
	if (! /^$prompt/) {
		if (! $skipprocess) {
			print STDERR "      ShowSysinfo Data: $_" if ($debug);
			ProcessHistory("","","","! $_");
		}
	}
    }
    ProcessHistory("","","","!\n!WLC Show Sysinfo End\n");
    print STDERR "    Exiting ShowSysinfo: $_" if ($debug);
    return(0);
}

# This routine parses "show udi"
sub ShowUdi {
    my($INPUT, $OUTPUT, $cmd) = @_;
    print STDERR "    In ShowUdi: $_" if ($debug);
    ProcessHistory("","","","\n!WLC Show Udi Start\n!\n");

    while (<$INPUT>) {
	tr/\015//d;

	last if (/^$prompt/);
	next if (/^(\s*|\s*$cmd\s*)$/);
	print STDERR "      ShowUdi Data: $_" if ($debug);
	ProcessHistory("","","","! $_");
    }
    ProcessHistory("","","","!\n!WLC Show Udi End\n");
    print STDERR "    Exiting ShowSysinfo: $_" if ($debug);
    return(0);
}



sub ShowAPInventory {
    my($INPUT, $OUTPUT, $cmd) = @_;
    print STDERR "    In ShowAPInventory: $_" if ($debug);
    ProcessHistory("","","","\n!WLC ShowAPInventory Start\n!\n");

    while (<$INPUT>) {
	tr/\015//d;

	last if (/^$prompt/);
	next if (/^(\s*|\s*$cmd\s*)$/);
	if (grep(/SN:/,$_) eq 0) {
		chomp $_;
	}
	print STDERR "      ShowAPInventory Data: $_" if ($debug);
	ProcessHistory("","","","! $_");
    }
    ProcessHistory("","","","!\n!WLC ShowAPInventory End\n");
    print STDERR "    Exiting ShowAPInventory: $_" if ($debug);
    return(0);
}


1;
