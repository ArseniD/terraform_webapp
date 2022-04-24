#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${s3_bucket_name}/static/index.html /home/ec2-user/index.html
aws s3 cp s3://${s3_bucket_name}/static/web_logo.png /home/ec2-user/web_logo.png
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/web_logo.png /usr/share/nginx/html/web_logo.png
