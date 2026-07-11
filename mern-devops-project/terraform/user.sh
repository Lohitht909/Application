#!/bin/bash
set -euxo pipefail

dnf update -y

# Install Git
dnf install -y git

# Install Docker
dnf install -y docker
systemctl enable docker
systemctl start docker

# Install Java 17
dnf install -y java-17-amazon-corretto

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

dnf install -y jenkins

systemctl enable jenkins
systemctl start jenkins

# Add Jenkins to Docker group
usermod -aG docker jenkins
systemctl restart jenkins

# Install NodeJS 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
dnf install -y nodejs

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
dnf install -y unzip
cd /tmp
unzip awscliv2.zip
./aws/install

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -m 0755 kubectl /usr/local/bin/kubectl

# Install eksctl
curl --silent --location \
https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz \
| tar xz -C /tmp

mv /tmp/eksctl /usr/local/bin

# Install Trivy
cat <<EOF >/etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
enabled=1
gpgcheck=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF

dnf install -y trivy

# Verify installations
docker --version
java -version
git --version
node -v
npm -v
aws --version
kubectl version --client
eksctl version
trivy --version