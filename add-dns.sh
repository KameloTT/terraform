#!/bin/bash

domainname=$1
cat > gitlab-record.json <<- "EOF"
{
            "Comment": "CREATE/DELETE/UPSERT a record ",
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                    "Name": "gitlab.$domainname.",
                                    "Type": "NS",
                                    "TTL": 300,
                                 "ResourceRecords": [
                                   {
                                     "Value": "ns-411.awsdns-51.com"
                                   },
                                   {
                                     "Value": "ns-1841.awsdns-38.co.uk"
                                   },
                                   {
                                     "Value": "ns-909.awsdns-49.net"
                                   },
                                   {
                                     "Value": "ns-1074.awsdns-06.org"
                                   }
                                 ]
                       }}]
}
EOF
zoneid=`aws route53 list-hosted-zones-by-name |  jq --arg name "${domainname}." -r '.HostedZones | .[] | select(.Name=="\($name)") | .Id'`
changeid=`aws route53 change-resource-record-sets --hosted-zone-id /hostedzone/$zoneid --change-batch file://gitlab-record.json |grep '"Id"' |awk -F'"' {'print $4'}`
while [ `aws route53  get-change --id $changeid |grep Status |awk -F'"' {'print $4'}` != 'INSYNC'  ]
do
sleep 1
echo 'wait'
done
