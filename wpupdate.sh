#!/bin/bash
# Path to Web Service Virtual Hosts
PATH="/etc/nginx/sites-available/"
EXTENTION="*.vhost"

# Search Query for Document Root ( [[:space:]] makes sure the query item returns the correct root and not %root% )
QUERY="root"

PATHARRAY=()

# Dowbload the latest version of Wordpress
echo "Downloading Wordpress"
/usr/bin/wget https://wordpress.org/latest.zip

echo "Extracting Wordpress Archive"
/usr/bin/unzip latest.zip

echo "Removing WP Sample Config"
/bin/rm wordpress/wp-config-sample.php

echo "Removing WP readme.html"
/bin/rm wordpress/readme.html

# Loop through Virtual Host Files
for f in $PATH$EXTENTION;
do
        #Clean Paths for Websites
	PATHARRAY+=( $(/bin/sed -n /$QUERY[[:space:]]/p $f | /bin/sed 's/root//g' | /usr/bin/tr -d ';' | /usr/bin/sort |/usr/bin/uniq -u))
done

for a in ${PATHARRAY[@]}
do

	# Check if Wordpress is installed for the path
	if [ -d "$a/wp-content" ]; then
  		# Upgrade Wordpress.
		echo "Upgrading " $a
		/bin/cp -R ./wordpress/* $a

		# Grab user for Site and correct permissions
		if [[ $a =~ /home/([A-Za-z]+) ]]; then
			echo "Changing Permissons for " $a " to " ${BASH_REMATCH[1]}
			/bin/chown -R ${BASH_REMATCH[1]}:${BASH_REMATCH[1]} $a
		fi

		# Configuring proper permissions for webserver to edit Wordpress content
		echo "Changing Permions on " $a"/wp-content"
	        /bin/chgrp -R www-data $a"/wp-content"
	        /bin/chmod -R g+w $a"/wp-content"
	        /bin/chmod g+s  $a"/wp-content"
	fi

done

# Perform cleanup after Upgrade is finished
echo "Removing Wordpress and Latest"
/bin/rm latest.zip
/bin/rm -rf wordpress/
echo "Updates and Clean Up are Complete"
echo "Complete Upgrader by /usr/bin/curl <domain>/wp-admin/upgrade.php?step=1&backto=%2Fwp-admin%2F >> /dev/null 2>&1"