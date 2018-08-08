Reason:
Aerohive do not track when a defined user last logged on to the network.  To manage the number of active PPSK users we need to know when a user last logged on.

Aerohive did not have the capability to schedule nightly reboots and we were seeing performance issues if APs did not reboot regularly

MISSING:
Export of usernames from Hive Manager
Aerohive configuration to send Syslogs to a collector
Syslog collector
File transfer of Syslog files to web server and database server

Flow:
User logins:
-On a regular basis, Username export from Hive Manager is imported using "ImportPPSK.pl"
-For every row in .csv file export a user is created if it starts with <USERNAME START> and set to Revoked TRUE
-Aerohive AP sends syslog messages to collector
-Syslog collector filters syslog messages for logins
-Once per day, Syslog collector sends collated file to database server
-Once per day, Database server parses login file using "AHScriptSpecify.pl"
-For every line in the file the script updates the database record for that user to the date provided in the login file
-Usernames that are active are set to Revoked FALSE
-Web server is then able to query this database for active and inactive users

Reboots:
-The script "Aerohive_SSH_PingReboot.pl" checks the status of each device provided from a text file argument
-If the device is pingable, "Aerohive_Reboot.expect" tries to SSH to the AP and reboot it