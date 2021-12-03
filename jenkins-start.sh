#!/bin/bash

[ "${JENKINS_HOME}" == "" ] &&
  JENKINS_HOME=/opt/jenkins/.jenkins
  export "JENKINS_HOME=/opt/jenkins/.jenkins"
[ "${JENKINS_LOG}" == "" ] &&
  JENKINS_LOG=${JENKINS_HOME}/jenkins.log
[ "${JENKINS_JAVA}" == "" ] &&
  JENKINS_JAVA=/usr/bin/java
[ "${JENKINS_JAVAOPTS}" == "" ] &&
  JENKINS_JAVAOPTS="-Xmx4096m -Djava.awt.headless=true -Duser.timezone=America/Los_Angeles"
[ "${JENKINS_IP}" == "" ] &&
  JENKINS_IP=0.0.0.0
[ "${JENKINS_PORT}" == "" ] &&
  JENKINS_PORT=$1
[ "${JENKINS_ARGS}" == "" ] &&
  JENKINS_ARGS=""

JENKINS_WAR=${JENKINS_HOME}/../jenkins.war

# check for config errors
JENKINS_ERRORS=()
[ ! -f ${JENKINS_WAR} ] &&
  JENKINS_ERRORS[${#JENKINS_ERRORS[*]}]="JENKINS_HOME : The jenkins.war could not be found at ${JENKINS_HOME}/jenkins.war"
[ ! -f $JENKINS_JAVA ] &&
  JENKINS_ERRORS[${#JENKINS_ERRORS[*]}]="JENKINS_JAVA : The java executable could not be found at $JENKINS_JAVA"

# display errors if there are any, otherwise start the process
if [ ${#JENKINS_ERRORS[*]} != '0' ]
then
  echo "CONFIGURATION ERROR:"
  echo "    The following errors occurred when starting Jenkins."
  echo "    Please set the appropriate values at /etc/sysconfig/jenkins"
  echo ""
  for (( i=0; i<${#JENKINS_ERRORS[*]}; i++ ))
  do
    echo "${JENKINS_ERRORS[${i}]}"
  done
  echo ""
  exit 1
else
  echo "starting service"
  echo "$JENKINS_JAVA $JENKINS_JAVAOPTS -jar $JENKINS_WAR --httpListenAddress=$JENKINS_IP --httpPort=$JENKINS_PORT >$JENKINS_LOG 2>&1 &"
  $JENKINS_JAVA $JENKINS_JAVAOPTS -jar $JENKINS_WAR --httpListenAddress=$JENKINS_IP --httpPort=$JENKINS_PORT >$JENKINS_LOG 2>&1 &
fi
