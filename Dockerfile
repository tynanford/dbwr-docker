FROM rockylinux/rockylinux:latest 

MAINTAINER Tynan Ford, tford@lbl.gov

ARG SERVICE_NAME
ARG SERVICE_PORT

RUN dnf upgrade -y && \
    dnf install -y git wget curl

# install java 17.0.2
RUN curl -O https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
RUN tar xvf openjdk-17.0.2_linux-x64_bin.tar.gz 
RUN mv jdk-17.0.2 /opt/jdk-17.0.2

ENV JAVA_HOME=/opt/jdk-17.0.2
ENV PATH="${PATH}:${JAVA_HOME}/bin" 

# install mvn 
RUN dnf install maven -y

RUN mvn -version

# install tomcat
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
RUN tar xvf apache-tomcat-9.*.tar.gz 
RUN mv apache-tomcat-*/ /opt/tomcat
ENV CATALINA_HOME="/opt/tomcat"
COPY ./config/setenv.sh ${CATALINA_HOME}/bin
RUN chown root:root ${CATALINA_HOME}/bin/setenv.sh
RUN chmod ug+x ${CATALINA_HOME}/bin/setenv.sh

ENV PATH="${PATH}:${CATALINA_HOME}/bin"

RUN sed -i.bak -e "s|Connector port=\"8080\"|Connector port=\"${SERVICE_PORT}\"|g" \
  -e 's|Server port="8005" shutdown="SHUTDOWN"|Server port="-1" shutdown="SHUTDOWN"|g' \
   /opt/tomcat/conf/server.xml

# clone service 
#RUN git clone https://github.com/ornl-epics/${SERVICE_NAME}.git
COPY ./phoebus /phoebus
RUN cd phoebus && mvn clean install -DskipTests
COPY ./${SERVICE_NAME} /${SERVICE_NAME}
RUN cd ${SERVICE_NAME} && mvn clean package
RUN cp /${SERVICE_NAME}/target/${SERVICE_NAME}.war ${CATALINA_HOME}/webapps

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
