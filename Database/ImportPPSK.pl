#!/usr/bin/perl -w
#Used to create the usernames from exported list in Hive Manager

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use NetAddr::IP;
use File::Copy;
use strict;
use warnings;
use Text::CSV;

print "Starting script to import PPSK users\n";
my $USERNAME="";
my $PPSK="";
my $EMAIL="";
my $DESCRIPTION="";
my $DATE=`date "+%d/%m/%Y"`;

# define the data source - dbi:DATABASETYPE:DATABASENAME:HOSTNAME:PORT
my $dsn = 'dbi:mysql:<DATABASENAME>:<HOSTNAME>:<PORT>';

# set the user and password
my $user = '<USERNAME>';
my $pass = '<PASSWORD>';

# now connect and get a database handle
my $dbh = DBI->connect($dsn, $user, $pass)
 or die "Can.t connect to the DB: $DBI::errstr\n";

#Reset all accounts to revoked
my $reset = $dbh->prepare("UPDATE LastLogin set Revoked=True");
$reset->execute;

my $file = "$ARGV[0]";
  open my $fh, "<", $file or die "$file: $!";

  my $csv = Text::CSV->new ({
      binary    => 1, # Allow special character. Always set this
      auto_diag => 1, # Report irregularities immediately
      });
  $csv->getline ($fh); # skip header

  while (my $row = $csv->getline ($fh)) {
	$USERNAME=$row->[0];
	if ($USERNAME=~ /<USERNAME START>(.*)/){
		$PPSK=$row->[1];
		$PPSK =~ s/^(.{7})([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/;'"%])/$1\\$2/g;
		$PPSK =~ s/^(.{6})([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/;'"%])(.{1,2})/$1\\$2$3/g;		$EMAIL=$row->[4];
		$EMAIL  =~ s/(.*)([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/;'"%])(.*)/$1\\$2$3/g;
		$DESCRIPTION=$row->[5];
		$DESCRIPTION  =~ s/(.*)([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/;'"%])(.*)/$1\\$2$3/g;
		my $sth = $dbh->prepare("INSERT INTO LastLogin (Username,Date,PPSK,Email,Description) VALUES ('$USERNAME', '$DATE', '$PPSK', '$EMAIL', '$DESCRIPTION') ON DUPLICATE KEY UPDATE Description=VALUES(Description), Email=VALUES(Email), Revoked=False");
		$sth->execute;
	}
      }
  close $fh;
