#!/bin/bash
set -exuo pipefail

JMETER_VERSION=5.1.1
JMETER_HOME=/opt/apache-jmeter
APACHE_MAVEN=$(mktemp -d -t apache-mavenXXXXXX)
APACHE_MAVEN_VERSION=3.6.3

sudo yum install -y epel-release
sudo yum install -y \
    xauth \
    java \
    bc \
    unzip \
    bash-completion \
    git \
    jq \
    lsof \
    mailx \
    man \
    patch \
    perl \
    pv \
    tree \
    htop \
    iftop \
    ps_mem \
    ack

pushd ${APACHE_MAVEN}
curl -s http://mirror.cogentco.com/pub/apache/maven/maven-3/${APACHE_MAVEN_VERSION}/binaries/apache-maven-${APACHE_MAVEN_VERSION}-bin.zip \
        > apache-maven-${APACHE_MAVEN_VERSION}-bin.zip \
    && unzip apache-maven-${APACHE_MAVEN_VERSION}-bin.zip
popd

curl -s https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
        > apache-jmeter-${JMETER_VERSION}.tgz \
    && tar xzf apache-jmeter-${JMETER_VERSION}.tgz \
    && rm apache-jmeter-${JMETER_VERSION}.tgz \
    && sudo mv apache-jmeter-${JMETER_VERSION} ${JMETER_HOME}

cd ${JMETER_HOME} \
    && curl -sL 'http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar' \
        > lib/ext/jmeter-plugins-manager-1.3.jar \
    && curl -sL http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
        > lib/cmdrunner-2.2.jar \
    && java -cp lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

curl -sL https://search.maven.org/remotecontent?filepath=com/google/code/gson/gson/2.8.5/gson-2.8.5.jar \
        > ${JMETER_HOME}/lib/gson-2.8.5.jar

sudo cp ${APACHE_MAVEN}/apache-maven-${APACHE_MAVEN_VERSION}/lib/maven-artifact-${APACHE_MAVEN_VERSION}.jar ${JMETER_HOME}/lib/
echo 'export PATH=$PATH:'${JMETER_HOME}'/bin' >> ~/.bashrc

./bin/PluginsManagerCMD.sh upgrades

sudo sysctl net.ipv4.tcp_tw_reuse=1
sudo sysctl net.ipv4.tcp_fin_timeout=1
sudo sysctl net.ipv4.ip_local_port_range="18000 65535"
