#!/bin/bash -xe

whoami

pwd

# crontab restart
systemctl restart cron.service

# Install jq Tool (for ops-agent debug)
sudo apt-get update
sudo apt install -y jq

# Config limits.conf nproc and nofile
cat > /etc/security/limits.conf << EOF
# /etc/security/limits.conf
#
#This file sets the resource limits for the users logged in via PAM.
#It does not affect resource limits of the system services.
#
#Also note that configuration files in /etc/security/limits.d directory,
#which are read in alphabetical order, override the settings in this
#file in case the domain is the same or more specific.
#That means for example that setting a limit for wildcard domain here
#can be overriden with a wildcard setting in a config file in the
#subdirectory, but a user specific setting here can be overriden only
#with a user specific setting in the subdirectory.
#
#Each line describes a limit for a user in the form:
#
#<domain>        <type>  <item>  <value>
#
#Where:
#<domain> can be:
#        - a user name
#        - a group name, with @group syntax
#        - the wildcard *, for default entry
#        - the wildcard %, can be also used with %group syntax,
#                 for maxlogin limit
#
#<type> can have the two values:
#        - "soft" for enforcing the soft limits
#        - "hard" for enforcing hard limits
#
#<item> can be one of the following:
#        - core - limits the core file size (KB)
#        - data - max data size (KB)
#        - fsize - maximum filesize (KB)
#        - memlock - max locked-in-memory address space (KB)
#        - nofile - max number of open file descriptors
#        - rss - max resident set size (KB)
#        - stack - max stack size (KB)
#        - cpu - max CPU time (MIN)
#        - nproc - max number of processes
#        - as - address space limit (KB)
#        - maxlogins - max number of logins for this user
#        - maxsyslogins - max number of logins on the system
#        - priority - the priority to run user process with
#        - locks - max number of file locks the user can hold
#        - sigpending - max number of pending signals
#        - msgqueue - max memory used by POSIX message queues (bytes)
#        - nice - max nice priority allowed to raise to values: [-20, 19]
#        - rtprio - max realtime priority
#
#<domain>      <type>  <item>         <value>
#

#*               soft    core            0
#*               hard    rss             10000
#@student        hard    nproc           20
#@faculty        soft    nproc           20
#@faculty        hard    nproc           50
#ftp             hard    nproc           0
#@student        -       maxlogins       4


* soft nproc 65535
* hard nproc 65535

* soft nofile 65535
* hard nofile 65535

# End of file
EOF

#Configure max open file
cat > /etc/sysctl.conf << EOF
# sysctl settings are defined through files in
# /usr/lib/sysctl.d/, /run/sysctl.d/, and /etc/sysctl.d/.
#
# Vendors settings live in /usr/lib/sysctl.d/.
# To override a whole file, create a new file with the same in
# /etc/sysctl.d/ and put new settings there. To override
# only specific settings, add a file with a lexically later
# name in /etc/sysctl.d/ and put new settings there.
#
# For more information, see sysctl.conf(5) and sysctl.d(5).
fs.file-max = 100000
EOF
sysctl -p

# Install ops-agent  //預設監控的項目：https://cloud.google.com/logging/docs/agent/ops-agent?hl=ja#features
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

systemctl enable google-cloud-ops-agent
systemctl status google-cloud-ops-agent

# Install docker
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io -y
chmod +x /var/run/docker.sock
systemctl start docker
systemctl enable docker.service

# install docker compose
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# JAVA
echo "Inatall Java"
apt install openjdk-17-jre-headless -y

# openvscode server
# https://github.com/gitpod-io/openvscode-server
echo "Inatall openvscode"
# export openvscode_server_version=1.65.2
wget https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v${openvscode_server_version}/openvscode-server-v${openvscode_server_version}-linux-x64.tar.gz
tar -xzf openvscode-server-v${openvscode_server_version}-linux-x64.tar.gz
mv openvscode-server-v${openvscode_server_version}-linux-x64 /usr/local/openvscode
# vscode extension
/usr/local/openvscode/bin/openvscode-server --install-extension vscjava.vscode-java-pack
/usr/local/openvscode/bin/openvscode-server --install-extension GabrielBB.vscode-lombok
/usr/local/openvscode/bin/openvscode-server --install-extension Pivotal.vscode-boot-dev-pack

# # 文件類型
/usr/local/openvscode/bin/openvscode-server --install-extension yzhang.markdown-all-in-one
/usr/local/openvscode/bin/openvscode-server --install-extension DavidAnson.vscode-markdownlint
# # 工具類型
/usr/local/openvscode/bin/openvscode-server --install-extension redhat.fabric8-analytics
/usr/local/openvscode/bin/openvscode-server --install-extension ms-azuretools.vscode-docker
/usr/local/openvscode/bin/openvscode-server --install-extension eamodio.gitlens
/usr/local/openvscode/bin/openvscode-server --install-extension mhutchie.git-graph
/usr/local/openvscode/bin/openvscode-server --install-extension PKief.material-icon-theme
/usr/local/openvscode/bin/openvscode-server --install-extension 42Crunch.vscode-openapi

# nohup /usr/local/openvscode/bin/openvscode-server --port 80 --host 0.0.0.0 --without-connection-token >/dev/null 2>&1 &
nohup /usr/local/openvscode/bin/openvscode-server --port 80 --host 0.0.0.0 --connection-token ${token} >/dev/null 2>&1 &

#
apt-get install postgresql-client -y


# UML Tool
# apt install -y graphviz