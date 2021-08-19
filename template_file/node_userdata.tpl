#! /bin/bash
## Log all to /var/log/user-data.log  ## tail -f /var/log/user-data.log|
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo apt-get update

########################################################
#Setting up SSM
########################################################
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.us-west-2.amazonaws.com/amazon-ssm-us-west-2/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo service amazon-ssm-agent start

#######################################################
#Setting up Node 14
#######################################################
sudo apt-get install gcc g++ make -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y

sudo apt -y install nodejs
sudo apt-get install gcc g++ make -y
sudo apt-get install build-essential -y

########################################################
#Setting up Nodex Express Boiler Plate
########################################################
#####Copy the project from / root to / home/ubuntu so ubuntu has permission to run it
git clone https://github.com/madhums/node-express-mongoose-demo.git ~/myproject


cd ~/myproject

#Add our mongo ip to the env example 
rm .env.example
cat > .env <<'EOF'
TWITTER_CLIENTID=<ID>
TWITTER_SECRET=<SECRET>
GITHUB_CLIENTID=<ID>
GITHUB_SECRET=<SECRET>
LINKEDIN_CLIENTID=<ID>
LINKEDIN_SECRET=<SECRET>
GOOGLE_CLIENTID=<ID>
GOOGLE_SECRET=<SECRET>
IMAGER_S3_KEY=AWS_S3_KEY
IMAGER_S3_SECRET=AWS_S3_SECRET
IMAGER_S3_BUCKET=AWS_S3_BUCKET
MONGODB_URL=mongodb://admin:admin@${mongo_ip}:27017/
EOF

###################################################################################################################
#Optional create the password using aws secrets manager and append the results as a variable here EG 
#echo MONGODB_URL=mongodb://$${mongo_username}:$${mongo_password} @ ${mongo_ip}:27017/test ~/myproject/.env

#####################################
#Starting up the node express app
####################################
# sudo npm install
sudo npm install --no-optional
sudo npm start


