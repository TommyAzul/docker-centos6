#!/bin/sh

export JAVA_HOME=/usr/java/latest
export CATALINA_BASE=/usr/share/tomcat7
export CATALINA_HOME=/usr/share/tomcat7
export JASPER_HOME=/usr/share/tomcat7
export CATALINA_TMPDIR=/usr/share/tomcat7/temp
export TOMCAT_LOG=/usr/share/tomcat7/logs/catalina.out
export CATALINA_PID=/var/run/tomcat7.pid

[ -f /usr/share/tomcat7/logs/catalina.out ] || touch /usr/share/tomcat7/logs/catalina.out
chown tomcat:tomcat /usr/share/tomcat7/logs/catalina.out

[ -f /var/run/tomcat7.pid ] || touch /var/run/tomcat7.pid
chown tomcat:tomcat /var/run/tomcat7.pid


