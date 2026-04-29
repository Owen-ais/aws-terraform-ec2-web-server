#!/bin/bash

dnf update -y
dnf install -y httpd

systemctl enable httpd
systemctl start httpd

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Terraform EC2 Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 40px;
        }

        .container {
            max-width: 850px;
            margin: auto;
            background: white;
            padding: 35px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h1 {
            color: #232f3e;
        }

        .tag {
            display: inline-block;
            background-color: #ff9900;
            color: #232f3e;
            font-weight: bold;
            padding: 6px 10px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        p {
            color: #555;
            font-size: 16px;
            line-height: 1.6;
        }

        .highlight {
            font-weight: bold;
            color: #000;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Terraform EC2 Web Server</h1>
        <div class="tag">Infrastructure as Code</div>

        <p><span class="highlight">Deployed using:</span> Terraform and AWS EC2</p>
        <p><span class="highlight">Web server:</span> Apache HTTP Server</p>
        <p><span class="highlight">Instance ID:</span> $INSTANCE_ID</p>
        <p><span class="highlight">Availability Zone:</span> $AZ</p>

        <h2>About This Project</h2>
        <p>
            This web server was created automatically using Terraform.
            Terraform provisioned the EC2 instance, security group, and user data script.
        </p>

        <h2>What This Shows</h2>
        <ul>
            <li>Creating AWS infrastructure using Terraform</li>
            <li>Deploying an EC2 instance with Infrastructure as Code</li>
            <li>Configuring security group rules</li>
            <li>Using User Data to install and start Apache automatically</li>
            <li>Outputting the public website URL from Terraform</li>
        </ul>
    </div>
</body>
</html>
EOF
