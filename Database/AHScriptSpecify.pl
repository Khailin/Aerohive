#!/usr/bin/perl -w
#Update list of users from text file supplied in argument, showing the last time they logged in

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use NetAddr::IP;
use File::Copy;
use strict;
use warnings;
use POSIX qw(strftime);

print "Starting script\n";
my $USERNAME="<GUEST NAME START>0001";
my $USERNAMELAST="Test";

# define the data source - dbi:DATABASETYPE:DATABASENAME:HOSTNAME:PORT
my $dsn = 'dbi:mysql:<DATABASENAME>:<HOSTNAME>:<PORT>';

# set the user and password
my $user = '<USERNAME>';
my $pass = '<PASSWORD>';

# now connect and get a database handle
my $dbh = DBI->connect($dsn, $user, $pass)
 or die "Can.t connect to the DB: $DBI::errstr\n";

open (my $fh, '<:encoding(UTF-8)', $ARGV[0])
 or die "Could not open file '$ARGV[0]' $!";

my $FIRSTLINE = <$fh>;
my $DATE = substr($FIRSTLINE, 0, 10);
print "Date of text file is $DATE\n";
while (my $LINE = <$fh>) {
	$USERNAMELAST = substr($LINE, -15);
	$USERNAME = substr($USERNAMELAST, 0, 13);
        
	my $sth = $dbh->prepare(" UPDATE LastLogin SET Date='$DATE', Revoked=false WHERE Username='$USERNAME'");
        $sth->execute;
}
print "Ending script\n"
