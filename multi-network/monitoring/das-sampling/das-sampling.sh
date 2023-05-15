#!/bin/bash

# Select node type
echo "Select node type:"
echo "1. Light storage nodes"
echo "2. Full storage nodes"
read NODE_CHOICE

# Set NODE_TYPE variable based on user input
case $NODE_CHOICE in
  1)
    NODE_TYPE="light"
    ;;
  2)
    NODE_TYPE="full"
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

# Prompt the user to set the interval in minutes
echo "Enter the interval in minutes:"
read INTERVAL

# Check if the interval is a number
if [[ $INTERVAL =~ ^[0-9]+$ ]]; then
  # Create the script to run the command and save the output
  SCRIPT_PATH="$HOME/das-repeater.sh"
  cat > "$SCRIPT_PATH" <<EOL
#!/bin/bash

GET_STATS="export CELESTIA_NODE_AUTH_TOKEN=\$(/usr/local/bin/celestia $NODE_TYPE auth admin --p2p.network blockspacerace); /usr/local/bin/celestia rpc das SamplingStats"

OUTPUT=\$(eval \$GET_STATS)
TEMP_SAMPLED=\$(echo "\$OUTPUT" | grep -oP '"head_of_sampled_chain":\K\d+')
TEMP_CATCHUP=\$(echo "\$OUTPUT" | grep -oP '"head_of_catchup":\K\d+')
TEMP_HEIGHT=\$(echo "\$OUTPUT" | grep -oP '"network_head_height":\K\d+')

TIMESTAMP=\$(date '+%Y-%m-%d %H:%M:%S')

echo "\$TIMESTAMP: TEMP-SAMPLED=\$TEMP_SAMPLED, TEMP-CATCHUP=\$TEMP_CATCHUP, TEMP-HEIGHT=\$TEMP_HEIGHT" | tee -a "$HOME/das-logfile.txt"
EOL

  # Make the script executable
  chmod +x "$SCRIPT_PATH"

  # Set up the cron job to run the script at the specified interval
  (crontab -l ; echo "*/$INTERVAL * * * * $SCRIPT_PATH") | crontab -

  echo "Cron job created to run the script every $INTERVAL minutes"
else
  echo "Invalid interval"
  exit 1
fi
