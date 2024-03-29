FROM rockylinux/rockylinux:latest 

MAINTAINER Tynan Ford, tford@lbl.gov


RUN dnf upgrade -y && \
    dnf install -y git wget curl

# install java 16.0.2
RUN curl -O https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz
RUN tar xvf openjdk-16.0.2_linux-x64_bin.tar.gz 
RUN mv jdk-16.0.2 /opt/jdk-16.0.2

ENV JAVA_HOME=/opt/jdk-16.0.2
ENV PATH="${PATH}:${JAVA_HOME}/bin" 

# install mvn 
RUN dnf install maven -y

RUN mvn -version

# install tomcat
#RUN wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.10/bin/apache-tomcat-10.0.10.tar.gz
RUN wget https://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
RUN tar xvf apache-tomcat-9.*.tar.gz
RUN mv apache-tomcat-*/ /opt/tomcat
ENV CATALINA_HOME="/opt/tomcat"
COPY ./setenv.sh ${CATALINA_HOME}/bin
RUN chown root:root ${CATALINA_HOME}/bin/setenv.sh
RUN chmod ug+x ${CATALINA_HOME}/bin/setenv.sh

ENV PATH="${PATH}:${CATALINA_HOME}/bin"

# clone pvws 
RUN git clone https://github.com/ornl-epics/pvws.git
RUN cd pvws && mvn clean package
RUN cp /pvws/target/pvws.war ${CATALINA_HOME}/webapps

# clone dbwr
RUN git clone https://github.com/ornl-epics/dbwr.git
RUN cd dbwr && mvn clean package
RUN cp /dbwr/target/dbwr.war ${CATALINA_HOME}/webapps

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

