#!/bin/bash

scanPath=""
if [ -n "$1" ]; then
    scanPath="$1"
    if [ ! -d "$scanPath" ]; then
        echo "Scan path does not exist."
        exit 1
    fi
else
    echo "Scan path cannot be empty."
    exit 1
fi

telegramEnable=true
telegramBotToken=""
if [ -n "$2" ]; then
    telegramBotToken="$2"
else
    telegramEnable=false
fi

telegramChatId=""
if [ -n "$3" ]; then
    telegramChatId="$3"
else
    telegramEnable=false
fi

hostNameType=""
if [ -n "$4" ]; then
    hostNameType="$4"
else
    hostNameType=$(hostname )
fi

if [ "$telegramEnable" = true ]; then
    if [ ! -f /usr/bin/curl ]; then
        echo "You should be install cURL first. Please use 'apt install curl' or 'yum install curl'."
        exit 1
    fi
fi

scanResult=$(find $scanPath -name "*.php" |xargs egrep -n 'assert|phpspy|c99sh|milw0rm|eval|\(gunerpress|\(base64_decoolcode|spider_bc|shell_exec|passthru|\(\$\_\POST\[|eval \(str_rot13|\.chr\(|\$\{\"\_P|eval\(\$\_R|file_put_contents\(\.\*\$\_|base64_decode')

scanResultTempFile="/tmp/temp_WebShellScanner_ScanResult.txt"

echo "$scanResult" >> $scanResultTempFile

scanResultTempFileSize=$(ls -l $scanResultTempFile | awk '{ print $5 }' )

if [ $scanResultTempFileSize -eq 1 ]; then
    scanResultRows=0
else
    scanResultRows=$(cat $scanResultTempFile|wc -l )
fi

rm $scanResultTempFile

if [ "$telegramEnable" = true ]; then
    if [ $scanResultRows == 0 ]; then
        curl -s -o /dev/null -X POST "https://api.telegram.org/bot$telegramBotToken/sendMessage" -d parse_mode=HTML -d chat_id=$telegramChatId -d text="<b>WebShellScanner - Scan Result</b>%0A%0AReport Server: $hostNameType%0AReport Date: $(date +%Y-%m-%d/%T)%0A%0A<i>Congratulations, no results find!</i>"
        echo "Congratulations, no results found!"
        exit 1
    else
        curl -s -o /dev/null -X POST "https://api.telegram.org/bot$telegramBotToken/sendMessage" -d parse_mode=HTML -d chat_id=$telegramChatId -d text="<b>WebShellScanner - Scan Result</b>%0A%0AReport Server: $hostNameType%0AReport Date: $(date +%Y-%m-%d/%T)%0A%0A<b>Scan Results: $scanResultRows file be find.</b>%0A%0A$scanResult"
        echo "Scan Result: $scanResultRows file be find."
        echo ""
        echo "$scanResult"
        exit 1
    fi
else
    if [ $scanResultRows == 0 ]; then
        echo "Congratulations, no results found!"
        exit 1
    else
        echo "Scan Result: $scanResultRows file be find."
        echo ""
        echo "$scanResult"
        exit 1
    fi
fi