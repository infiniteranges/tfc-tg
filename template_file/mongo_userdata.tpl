#! /bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
################################
#Update the instance
###############################

sudo apt-get update

################################
#Setup SSM so we can ssh using ssm
################################

mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.us-west-2.amazonaws.com/amazon-ssm-us-west-2/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo service amazon-ssm-agent start



################################
#installing mongo db
################################

### Digital ocean tuts url https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-mongodb-on-ubuntu-16-04
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install mongodb-org -y
sudo systemctl start mongod
sudo systemctl enable mongod

sleep 2
########################################################
##Create the test db
########################################################



########################################################
#Setting up username and password for mongo db
########################################################
mongo <<'EOF'
use admin
db.createUser({	user: "admin",pwd: "admin",roles:[{role: "root" , db:"admin"}]})
exit
EOF

sleep 2
echo "Creating Admin user completed"
sudo service mongod restart



################################
#Setting up mongo db
################################

echo "Setting up default settings"

mv /etc/mongod.conf /etc/mongod.conf.bak
touch /etc/mongod.conf
cat > /etc/mongod.conf <<'EOF'
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0

security:
  authorization: "enabled"

# mongodb.conf
EOF


################################
#completed setting up mongo db
################################
sudo service mongod restart
touch complete

