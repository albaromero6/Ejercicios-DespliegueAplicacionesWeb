sudo apt update && sudo apt upgrade -y

wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb

sudo chmod 644 ~/jdk-21_linux-x64_bin.deb

sudo update-alternatives --remove java /usr/lib/jvm/jdk-21/bin/java
sudo update-alternatives --remove javac /usr/lib/jvm/jdk-21/bin/javac

sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-21.0.5-oracle-x64/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-21.0.5-oracle-x64/bin/javac 1

sudo update-alternatives --config java
sudo update-alternatives --config javac

sudo groupadd tomcat

sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.2/bin/apache-tomcat-11.0.2.tar.gz -O /tmp/tomcat.tar.gz

sudo mkdir /opt/tomcat

sudo tar xzvf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1

sudo chown -R ubuntu:ubuntu /opt/tomcat
sudo chmod -R 755 /opt/tomcat

