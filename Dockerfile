From ubuntu:trusty
RUN apt-get -y update
RUN apt-get -y install wget
RUN wget --no-cookies \
--no-check-certificate \
--header "Cookie: oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz" \
-O jdk-8u111-linux-x64.tar.gz
RUN tar -xzvf jdk-8u111-linux-x64.tar.gz -C /usr/local/
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/local/jdk1.8.0_111/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/jdk1.8.0_111/bin/javac" 1
RUN update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/jdk1.8.0_111/bin/javaws" 1
RUN update-alternatives --install "/usr/bin/jps" "jps" "/usr/local/jdk1.8.0_111/bin/jps" 1
RUN export JAVA_HOME=/usr/local/jdk1.8.0_111/
RUN export PATH=$JAVA_HOME/bin:$PATH
RUN export PATH=$PATH:$JAVA_HOME/bin
RUN echo 'export JAVA_HOME=/usr/java/jdk1.8.0_25/' >> ~/.bash_profile
RUN echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
RUN echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bash_profile
RUN rm -rf jdk-8u111-linux-x64.tar.gz
RUN wget --content-disposition "http://apache.mirrors.tds.net/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz"
RUN tar -xzvf apache-tomcat-8.5.9.tar.gz -C /usr/local/
RUN export CATALINA_HOME=/usr/local/apache-tomcat-8.5.9/
RUN echo 'CATALINA_HOME=/usr/local/apache-tomcat-8.5.9/' >> ~/.bash_profile
RUN rm -rf apache-tomcat-8.5.9.tar.gz
RUN mkdir maindownload
RUN apt-get -y install unzip

RUN wget -P maindownload --content-disposition "http://afdd8b5f.ngrok.io/nexus/service/local/artifact/maven/redirect?r=snapshots&g=HelloMiracle&a=HelloMiracle&v=LATEST&e=war"

RUN rm -rf /usr/local/apache-tomcat-8.5.9/webapps/ROOT/*
RUN unzip -qq maindownload/*.war -d /usr/local/apache-tomcat-8.5.9/webapps/ROOT/

RUN rm -rf maindownload
ENTRYPOINT /usr/local/apache-tomcat-8.5.9/bin/startup.sh && tail -f /usr/local/apache-tomcat-8.5.9/logs/catalina.out
