#!/bin/bash

# Steps to configure the script
# 1. Download the script to your home directory on the Linux hosting or the local Linux machine
# 2. Please replace the following values in the script with your own values:
#  - URL: Enter the URL of the website you want to check.
#  - THRESHOLD: Set the download time threshold. If the website load time exceeds this value, a notification will be sent.
#  - TELEGRAM_BOT_TOKEN: Enter the token of your Telegram bot.
#  - TELEGRAM_CHAT_ID: Enter the ID of the chat to send notifications to.
# 3. Open the editor crontab:
#   crontab -e
# 4. Add such rows to the crontab and configure the code execution frequency:
#   * * * * * /path/to/your/script.sh
# Each asterisk corresponds to a certain time parameter:
#  *: minute (0–59)
#  *: hour (0–23)
#  *: day of the month (1-31)
#  *: month (1–12)
#  *: day of the week (0–7, where Sunday can be either 0 or 7).
#  5. Set up secure permissions and make the script executable
#    chmod 700 /path/to/your/script.sh
#  6. Check if the script works correctly
#   bash /path/to/your/script.sh
#
# Here’s a concise guide to creating a Telegram bot:

# 1. Open Telegram and search for the "BotFather" bot.
# 2. Start a chat with BotFather and send the command /newbot.
# 3. Follow the prompts to name your bot and choose a username.
# 4. Copy the API token provided by BotFather.
# 5. Use the token to interact with Telegram’s API and control your bot.

# To get TELEGRAM_CHAT_ID:
# 1. Start a chat with your bot.
# 2. Send a message to the bot.
# 3. Visit https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates.
# 4. Find the chat_id in the JSON response.

# To make the bot as an admin of your channel:
# 1. Open Telegram and go to your channel.
# 2. Tap "Channel Info" and select "Administrators".
# 3. Add your bot by searching for its username.
# 4. Grant admin privileges to the bot.


# Here is a script

# URL to be checked
URL="https://yourwebsite.com"

# The treshold set for loading (sec)
THRESHOLD=2.0

# Telegram bot data
TELEGRAM_BOT_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"

# Checking the load time with the help of cURL
#cURL flags
#-o  Write to file instead of stdout. In this case, stdout is ignored because it is written to /dev/null
#-s silent mode
#-w (write-out) Make curl display information on stdout
#time_total - The total time, in seconds, that the full operation lasted.


LOAD_TIME=$(curl -o /dev/null -s -w "%{time_total}\n" $URL)

# Displaying the results for the load time
echo "Time to load $URL: $LOAD_TIME seconds"

# Checking if the load time exceeds the treshhold
# bc -l is used to handle floating-point comparisons
if (( $(echo "$LOAD_TIME > $THRESHOLD" | bc -l) )); then
  # If yes, such a message is sent to Telegram chanel
  MESSAGE="⚠️ Alert! The load time for $URL exceeded the threshold. It took $LOAD_TIME seconds to load."

  # Sending the HTTP POST request to the Telegram bot interacting with Telegram API. The Telegram bot publishes the message in your Telegram chanel.
  # The cURL command is used
  # cURL flags:
  # -s silent mode
  # -X - used when you want to change the default GET method to another, for example to POST
  # -d - sending HTTP POST data
 
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
       -d chat_id="$TELEGRAM_CHAT_ID" \
       -d text="$MESSAGE"
  
  echo "Notification sent to Telegram."
else
  echo "Load time is within the acceptable threshold."
fi

# storing logs about successful attempts (optional)
echo "Script ran at $(date)" >> /home/username/logfile.txt

