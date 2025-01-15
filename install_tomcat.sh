#!/bin/bash

# Desactivar la pantalla de actualización de kernel
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

# Actualizar repositorios y paquetes
sudo apt update && sudo apt upgrade -y

# Crear usuario 'tomcat'
sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat

# Descargar e instalar Java 21
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
sudo dpkg -i jdk-21_linux-x64_bin.deb

# Eliminar el archivo .deb después de instalación
rm -f jdk-21_linux-x64_bin.deb

# Descargar Tomcat 11.0.2
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.2/bin/apache-tomcat-11.0.2.tar.gz
tar -xvzf apache-tomcat-11.0.2.tar.gz

# Mover Tomcat a /opt/tomcat
sudo mv apache-tomcat-11.0.2 /opt/tomcat

# Cambiar propietario y permisos
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/apache-tomcat-11.0.2/bin

# Configurar usuarios en tomcat-users.xml
sudo sed -i '/<\/tomcat-users>/i \
<role rolename="manager-gui"/>\n\
<role rolename="admin-gui"/>\n\
<user username="manager" password="manager_secret" roles="manager-gui"/>\n\
<user username="admin" password="admin_secret" roles="manager-gui,admin-gui"/>' /opt/tomcat/apache-tomcat-11.0.2/conf/tomcat-users.xml

# Permitir acceso desde cualquier host a Manager y Host-Manager
sudo sed -i '/<Valve /,/\/>/ s|<Valve|<!--<Valve|; /<Valve /,/\/>/ s|/>|/>-->|' /opt/tomcat/apache-tomcat-11.0.2/webapps/manager/META-INF/context.xml
sudo sed -i '/<Valve /,/\/>/ s|<Valve|<!--<Valve|; /<Valve /,/\/>/ s|/>|/>-->|' /opt/tomcat/apache-tomcat-11.0.2/webapps/host-manager/META-INF/context.xml

# Crear servicio systemd para Tomcat
sudo bash -c 'cat << EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/jdk-21.0.5-oracle-x64"
Environment="CATALINA_PID=/opt/tomcat/apache-tomcat-11.0.2/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat/apache-tomcat-11.0.2"
Environment="CATALINA_BASE=/opt/tomcat/apache-tomcat-11.0.2"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/apache-tomcat-11.0.2/bin/startup.sh
ExecStop=/opt/tomcat/apache-tomcat-11.0.2/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF'

# Recargar los servicios systemd y habilitar Tomcat al inicio
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Limpiar archivos temporales
rm -f /tmp/apache-tomcat-11.0.2.tar.gz

echo "Instalación de Apache Tomcat 11.0.2 completada"