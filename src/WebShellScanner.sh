#!/bin/bash

VER="0.0.2"

scanPath=""
telegramEnable=false
telegramBotToken=""
telegramChatId=""
hostNameType=""
logfilepath=""

while getopts "p:t:c:n:l:h" arg; do
      case $arg in
      h)
        echo ""
        echo ""
        echo ""
        echo "==================================================================================="
        echo ""
        echo "WebShellQuickScanner Help Information"
        echo ""
        echo "-p <PATH>                        Scan Path."
        echo "-t <Telegram Bot Token>          Telegram Bot Token."
        echo "-t <Telegram Chat id>            Telegram Chat id."
        echo "-n <HostName>                    Customize HostName."
        echo "-l <PATH>                        Log file save path(Do not be end with '/')."
        echo ""
        echo ""
        echo "WebShellQuickScanner - Ver: $VER"
        echo "Made by DeepSkyFire"
        echo "https://github.com/DeepSkyFire/WebShellQuickScanner"
        echo ""
        echo "==================================================================================="
        echo ""
        echo ""
        echo ""
        exit 1
      ;;
      p)
        if [ -n "$OPTARG" ]; then
            scanPath=$OPTARG
            if [ ! -d "$scanPath" ]; then
                echo "Scan path does not exist."
                exit 1
            fi
        else
            echo "Scan path cannot be empty."
            exit 1
        fi
      ;;
      t)
        if [ -n "$OPTARG" ]; then
            telegramBotToken="$OPTARG"
        fi
      ;;
      c)
        if [ -n "$OPTARG" ]; then
            telegramChatId="$OPTARG"
        fi
      ;;
      n)
        if [ -n "$OPTARG" ]; then
            hostNameType="$OPTARG"
        fi
      ;;
      l)
        if [ -n "$OPTARG" ]; then
            logfilepath="$OPTARG"
            if [ ! -d "$logfilepath" ]; then
                echo "Log file save path does not exist."
                exit 1
            fi
        fi
      ;;
      ?)
        echo "Invalid parameter. You can using '-h' to check help information."
        exit 1
      ;;
      esac
done

if [[ -n $telegramBotToken ]] && [[ -n $telegramChatId ]]; then
    telegramEnable=true
    if [ ! -f /usr/bin/curl ]; then
        echo "You should be install cURL first. Please use 'apt install curl' or 'yum install curl'."
        exit 1
    fi
    if [ ! -n $hostNameType ]; then
        hostNameType=$(hostname )
    fi
fi

if [ ! -n $logfilepath ]; then
    logfilepath="/dev/null"
else
    logfilepath="$logfilepath/WebShellQuickScanner_ScanLog_$(date +%Y-%m-%d.%T).txt"
fi

scanResult=$(find $scanPath -name "*.php" |xargs egrep -n 'assert|phpspy|c99sh|milw0rm|eval|create_function|register_shutdown_function|\(gunerpress|\(base64_decoolcode|spider_bc|shell_exec|passthru|\(\$\_\POST\[|\(\$\_\REQUEST\[|\(\$\_\GET\[|\(\$\_\FILE\[|\(\$\_\SESSION\[|eval \(str_rot13|\.chr\(|\$\{\"\_P|eval\(\$\_R|file_put_contents\(\.\*\$\_|file_get_contents\(\.\*\$\_|base64_decode')

scanResultTempFile="/tmp/temp_WebShellQuickScanner_ScanResult.txt"

echo "$scanResult" >> $scanResultTempFile
echo "$scanResult" >> $logfilepath

scanResultTempFileSize=$(ls -l $scanResultTempFile | awk '{ print $5 }' )

if [ $scanResultTempFileSize -eq 1 ]; then
    scanResultRows=0
else
    scanResultRows=$(cat $scanResultTempFile|wc -l )
fi

rm $scanResultTempFile

if [ "$telegramEnable" = true ]; then
    if [ $scanResultRows == 0 ]; then
        curl -s -o /dev/null -X POST "https://api.telegram.org/bot$telegramBotToken/sendMessage" -d parse_mode=HTML -d chat_id=$telegramChatId -d text="<b>WebShellQuickScanner - Scan Result</b>%0A%0AReport Server: $hostNameType%0AReport Date: $(date +%Y-%m-%d/%T)%0A%0A<i>Congratulations, no results find!</i>"
        echo "Congratulations, no results found!"
        exit 1
    else
        curl -s -o /dev/null -X POST "https://api.telegram.org/bot$telegramBotToken/sendMessage" -d parse_mode=HTML -d chat_id=$telegramChatId -d text="<b>WebShellQuickScanner - Scan Result</b>%0A%0AReport Server: $hostNameType%0AReport Date: $(date +%Y-%m-%d/%T)%0A%0A<b>Scan Results: $scanResultRows file be find.</b>%0A%0A$scanResult"
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