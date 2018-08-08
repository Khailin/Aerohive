#!/usr/bin/perl -w

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use NetAddr::IP;
use File::Copy;

print header;
print start_html;

print end_html;

# define the data source - dbi:DATABASETYPE:DATABASENAME:HOSTNAME:PORT
my $dsn = 'dbi:mysql:<DATABASENAME>:<HOSTNAME>:<PORT>';

# set the user and password
my $user = '<USERNAME>';
my $pass = '<PASSWORD>';

# now connect and get a database handle
my $dbh = DBI->connect($dsn, $user, $pass)
 or die "Can.t connect to the DB: $DBI::errstr\n";

# define and execute query to match user input to sitename
#my $sth = $dbh->prepare("select * from LastLogin where Username = '$user'");
#$sth->execute;

# define mysql query and execute it
my $query1 = qq{select Username from LastLogin ORDER BY Username};
my $sth= $dbh->prepare($query1);
$sth->execute;
my @users =();
while (my ($user) = $sth->fetchrow_array) {
        push @users, $user;
}

print <<END_of_start;
<a href="http://<WEB SERVER>/<WEBSITE>/index.html">Return to Aerohive User Management Menu</a>
<br>
<br>

<table border="1">
<tr>
<td><b>Username</td>
<td><b>Last Login</td>
<td><b>PPSK</td>
<td><b>Email</td>
<td><b>Description</td>
<td><b>Revoked</td>
</tr>
<tr>

END_of_start
foreach (@users){

        my $sth = $dbh->prepare("select * from LastLogin where Username = '$_'");
        $sth->execute;

        while(my($user, $date, $ppsk, $description, $email, $revoked) = $sth->fetchrow_array()) {

        $USER=$user;
        $DATE=$date;
        $PPSK=$ppsk;
        $DESCRIPTION=$description;
        $EMAIL=$email;
	if($revoked) {
		$REVOKED="True";
		}
	else {
		$REVOKED="False";
		}
        }

        print <<END_of_start;

        <tr>
        <td>$USER</td>
        <td>$DATE</td>
        <td>$PPSK</td>
        <td>$EMAIL</td>
        <td>$DESCRIPTION</td>
	<td>$REVOKED</td>
        </tr>
END_of_start

};

print <<END_of_start;

</table>

<br>
<br>
<a href="http://<WEB SERVER>/<WEBSITE>/index.html">Return to Aerohive User Management Menu</a>
<br>
<br>
<br>
<br>

END_of_start
