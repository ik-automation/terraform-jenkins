#!/bin/bash

set -euo

echo "RUN Jenkins"

waitForJenkins() {
    echo "Waiting jenkins to launch on 8080..."
    while ! nc -z localhost 8080; do
      sleep 0.1 # wait for 1/10 of the second before check again
    done
    echo "Jenkins launched"
}

# Add to jenkins user
echo "Install Jenkins"
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install -y jenkins
sudo service jenkins start
sleep 10
sudo service jenkins stop
sleep 10

usermod -aG docker ubuntu # make "docker start" work for ubuntu to remove
usermod -aG docker jenkins
systemctl enable docker
systemctl daemon-reload
service docker restart

REF="${JENKINS_HOME}/plugins"
REF_DIR="/usr/share/jenkins/plugins"
COUNT_PLUGINS_INSTALLED=0

rm -rf $REF/*
mkdir -p $REF_DIR
rm -rf $REF_DIR/*

sudo service jenkins stop

# INSTALL PLUGINS
while read -r spec || [ -n "$spec" ]; do
    plugin=()
    IFS=' ' read -r -a plugin <<< "${spec//:/ }"
    [[ ${plugin[0]} =~ ^# ]] && continue
    [[ ${plugin[0]} =~ ^[[:space:]]*$ ]] && continue
    [[ -z ${plugin[1]} ]] && plugin[1]="latest"

    JENKINS_UC_DOWNLOAD=$JENKINS_UC/download
    echo "Downloading ${plugin[0]}:${plugin[1]} into $REF_DIR"
    curl --retry 3 --retry-delay 5 -sSL -f "${JENKINS_UC_DOWNLOAD}/plugins/${plugin[0]}/${plugin[1]}/${plugin[0]}.hpi" \
				-o "$REF_DIR/${plugin[0]}.jpi"
    unzip -qqt "$REF_DIR/${plugin[0]}.jpi"
		# rm -f "$REF_DIR/${plugin[0]}.jpi"
    (( COUNT_PLUGINS_INSTALLED += 1 ))
done  < "/usr/local/bin/plugins.txt"

echo "---------------------------------------------------"
if (( "$COUNT_PLUGINS_INSTALLED" > 0 ))
then
    echo "INFO: Successfully installed $COUNT_PLUGINS_INSTALLED plugins."
else
    echo "INFO: No changes, all plugins previously installed."
fi
echo "---------------------------------------------------"

chown jenkins:jenkins $REF_DIR/
cp $REF_DIR/* $REF/

chown jenkins:jenkins /usr/local/bin/jenkins.yml
mkdir -p $CASC_JENKINS_CONFIG
cp /usr/local/bin/jenkins.yml $CASC_JENKINS_CONFIG
chown jenkins:jenkins $CASC_JENKINS_CONFIG/jenkins.yml

sudo service jenkins restart
# /etc/init.d/jenkins start
sleep 10
echo "Jenkins is ready"