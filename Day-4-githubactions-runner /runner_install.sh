# 1. Update OS and install dependencies
sudo yum update -y
sudo yum install -y git curl tar gzip

# 2. Create directory
mkdir actions-runner && cd actions-runner

# 3. Download runner
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64.tar.gz
tar xzf ./actions-runner.tar.gz

# 4. Configure runner (from GitHub UI)
./config.sh --url https://github.com/username/repo --token YOUR_TOKEN --labels amazonlinux,dev --name ec2-runner

# 5. Start runner
./run.sh &

# 6. Optional: install as service
sudo ./svc.sh install
sudo ./svc.sh start
