#!/bin/bash -e
ls -lha
cd gemfire-security
mvn clean package -DskipTests=true
ls -lha
cp security/security-templates-server/target/security-templates-server*.jar ../gemfire-security-jar/security.jar
