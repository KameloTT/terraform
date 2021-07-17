#!/bin/bash

domainname=$1
cat > gitlab-record.json <<EOF
{
            "Comment": "CREATE/DELETE/UPSERT a record ",
            "Changes": [{
            "Action": "UPSERT",
                        "ResourceRecordSet": {
                                    "Name": "gitlab.$domainname.",
                                    "Type": "NS",
                                    "TTL": 300,
                                 "ResourceRecords": [
                                   {
                                     "Value": "ns-707.awsdns-24.net"
                                   },
                                   {
                                     "Value": "ns-385.awsdns-48.com"
                                   },
                                   {
                                     "Value": "ns-1217.awsdns-24.org"
                                   },
                                   {
                                     "Value": "ns-1754.awsdns-27.co.uk"
                                   }
                                 ]
                       }}]
}
EOF
zoneid=`aws route53 list-hosted-zones-by-name |  jq --arg name "${domainname}." -r '.HostedZones | .[] | select(.Name=="\($name)") | .Id'`
changeid=`aws route53 change-resource-record-sets --hosted-zone-id $zoneid --change-batch file://gitlab-record.json |grep '"Id"' |awk -F'"' {'print $4'}`
while [ `aws route53  get-change --id $changeid |grep Status |awk -F'"' {'print $4'}` != 'INSYNC'  ]
do
sleep 1
echo 'wait'
done
