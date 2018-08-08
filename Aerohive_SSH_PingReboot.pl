#!/usr/bin/perl
use Net::SSH2;
use Net::Ping;
use strict;
use warnings;

my $filename = $ARGV[0];

open my $fh, '<', $filename or die "Cannot open $filename: $!";
my $p = Net::Ping->new("icmp");

while ( my $line = <$fh> )
{
	if( $p->ping($line,3) )
		{
		print "Host is alive: ".$line;
		system("<SCRIPTS HOME>/Aerohive_Reboot.expect $line");
	}
else
	{
	print "Host appears to be down: ".$line;
	}
}

close($fh);
$p->close();
