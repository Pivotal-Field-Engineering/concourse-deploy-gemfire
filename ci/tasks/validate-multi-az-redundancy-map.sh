#!/bin/bash -e
ls -lha
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" $GEMFIRE_CLIENT_URL
sudo dpkg -i pivotal-gemfire.deb

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "list members" \
-e "create region --name=testing --redundant-copies=1 --type=PARTITION_REDUNDANT" \
-e "put --key=('1') --value=('A') --region=testing" \
-e "put --key=('2') --value=('B') --region=testing" \
-e "put --key=('3') --value=('C') --region=testing" \
-e "put --key=('4') --value=('D') --region=testing" \
-e "put --key=('5') --value=('E') --region=testing" \
-e "put --key=('6') --value=('F') --region=testing" \
-e "put --key=('7') --value=('G') --region=testing" \
-e "put --key=('8') --value=('H') --region=testing" \

for ((n=0;n<$SERVER_COUNT;n++))
do
 -e "describe config --member=cacheserver-${n}" \
done
-e "show metrics --categories=partition --region=testing" > gemfire-output.txt
cat gemfire-output.txt

# checks redundancy in regions using the suggested method from pivotal docs:
# http://gemfire.docs.pivotal.io/docs-gemfire/latest/developing/partitioned_regions/checking_region_redundancy.html
cat gemfire-output.txt | grep numBucketsWithoutRedundancy | grep "| 0" &&
cat gemfire-output.txt | grep redundancy-zone | grep ": $AZ_PREFIX"1 &&
cat gemfire-output.txt | grep redundancy-zone | grep ": $AZ_PREFIX"2 &&
cat gemfire-output.txt | grep redundancy-zone | grep ": $AZ_PREFIX"3
