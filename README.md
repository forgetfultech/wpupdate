
WPUpdate
==========================================================

Is a simple utility, that allows you to update multiple instances of wordpress simple by running this script.

Make sure the following items are pointed the correct paths and formats for your setup

PATH="" (Path to your virtual host files e.g. /etc/nginx/sites-available)
EXTENTION="" (Extension of your virtual host files e.g. *.vhost)
QUERY="" (Search String for the Document Root found in your virtual host file e.g, root)

*NOTE* In the file loop root has been manually placed into the sed -e command, change this to whatever QUERY is set to

Running the script is a simple as:
sudo bash ./wpupdate.sh