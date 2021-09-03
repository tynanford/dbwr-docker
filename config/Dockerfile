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

# install ant
RUN wget -c http://mirrors.advancedhosters.com/apache/ant/binaries/apache-ant-1.10.11-bin.tar.gz
RUN tar xvf apache-ant-1.10.11-bin.tar.gz
RUN mv apache-ant-*/ /opt/ant
RUN ln -s /opt/ant/bin/ant /usr/bin/ant
COPY ./ant.sh /etc/profile.d/ant.sh
RUN source /etc/profile.d/ant.sh

RUN ant -version

# install tomcat
#RUN wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.10/bin/apache-tomcat-10.0.10.tar.gz
RUN wget https://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-9/v9.0.52/bin/apache-tomcat-9.0.52.tar.gz
RUN tar xvf apache-tomcat-9.0.52.tar.gz 
RUN mv apache-tomcat-*/ /opt/tomcat
ENV CATALINA_HOME="/opt/tomcat"

# clone pvws 
RUN git clone https://github.com/kasemir/pvws.git
RUN cd pvws && ant clean war
RUN cp pvws/pvws.war ${CATALINA_HOME}/webapps
COPY ./setenv.sh ${CATALINA_HOME}/bin

# clone dbwr
COPY ./test.bob /test.bob
RUN git clone https://github.com/kasemir/dbwr.git
RUN cd dbwr && ant clean war
RUN cp dbwr/dbwr.war ${CATALINA_HOME}/webapps

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

