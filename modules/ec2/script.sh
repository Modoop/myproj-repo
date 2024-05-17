#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>This message is from : $(hostname -i)</h1>" > /var/www/html/index.html
