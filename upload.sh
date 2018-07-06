#!/bin/ksh 

if [[ $# -ne 5 ]]
then
    echo -e "\nUSAGE : `basename $0`  <file name> <bucket name> <contentType> <s3Key> <s3Secret>"
        exit 1
fi

package=$1
bucketName=$2
contentType=$3
AWSKey=$4
AWSSecretKey=$5


file=$package
bucket=$bucketName
resource="/${bucket}/${file}"
contentType="$contentType"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
s3Key=$AWSKey
s3Secret=$AWSSecretKey
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -X PUT -T "${file}" \
  -H "Host: ${bucket}.s3.amazonaws.com" \
  -H "Date: ${dateValue}" \
  -H "Content-Type: ${contentType}" \
  -H "Authorization: AWS ${s3Key}:${signature}" \
  https://${bucket}.s3.amazonaws.com/${file}

