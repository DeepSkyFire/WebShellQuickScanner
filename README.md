WebShellQuickScanner
==============

Copyright
-------------
Copyright (c) 2020 by DeepSkyFire <https://github.com/DeepSkyFire>

About
--------------
A quick scan tool to find webshell or High-risk file on php file in Linux and push scaned result to telegram. 

This tool can help you check webshell file in your linux server. But that it does not delete any files. 
that it'll only list the files that use the high-risk PHP function, and everything is left to your own judgment. 

### It's not a substitute for antivirus software. The results are for reference only.

Multi-language
--------------

[Simplified Chinese 简体中文](https://www.vpstry.com/archives/555.html)

[Traditional Chinese 繁體中文](https://deepskyfire.com/sub/10.html)

[Japanese 日本語](https://qiita.com/DeepSkyFire/items/bf43f0a5ccf672e135dc)


Quick start
--------------

### Obtaining WebShellQuickScanner

    wget --no-check-certificate https://raw.githubusercontent.com/DeepSkyFire/WebShellQuickScanner/master/src/WebShellScanner.sh && chmod +x WebShellScanner.sh

### Quick Scan

    ./WebShellScanner.sh -p /data/www-data

Detailed description
--------------

### Dependencies.

Usage this tool push to telegram need you installed cURL first.

### Push to Telegram.

You need register a bot in telegram. Your can search @BotFather in telegram to register. 
At the same time you must be know yourself chat id.

### About HostName.

You can customize a HostName for this server. 
if you not customize a hostname, that will read hostname by system setting.
The only purpose of the host name is to add it to the message push to Telegram as an identifier to identify the server.

### About save log file.

if you want to save log file in server, you can using the following settings:

    ./WebShellScanner.sh -p /data/www-data -l /home/wwwwlogs

Attention! Do not be end with '/'!

### Complete example

if you want to scan path "/data/www-data" and save log file to "/home/wwwlogs", and push scaned result to telegram using customize hostname, you can using the following settings:

    ./WebShellScanner.sh -p /data/www-data -t TELEGRAM_BOT_TOKEN -c TELEGRAM_CHAT_ID -n MyServer1 -l /home/wwwwlogs

### Help information

    ./WebShellScanner.sh -h

### Periodic inspection

You can use `crontab` for scheduled scans.


Parameter Description
--------------

    WebShellScanner.sh [-h] [-p <SCAN PATH>] [-t <TELEGRAM BOT TOKEN>] [-c <TELEGRAM CHAT ID>] [-n <HostName>] [-l <SAVE LOG FILE PATH>]

The following command line options are allowed:

- `-h` Display help. Optional.

- `-p <SCAN PATH>` Set scan path.

- `-t <TELEGRAM BOT TOKEN>` Telegram Bot Token. Optional.

- `-c <TELEGRAM CHAT ID>` Telegram Chat id. Optional.

- `-n <HostName>` Customize HostName. Optional.

- `-l <SAVE LOG FILE PATH>` Log file save path(Do not be end with '/'). Optional.

License
--------------

The project is released under the terms of the GPLv3.
