#!/bin/bash
last_block=0
echo "[*] Initializing Background Pipeline Sync..." >> pipeline.log

while true; do
  payload=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' 'https://arb-sepolia.g.alchemy.com/v2/Lzxf6W8ICylZ6ddDyv-7M')
  current_hex=$(echo "$payload" | jq -r '.result // empty')
  
  if [ ! -z "$current_hex" ] && [ "$current_hex" != "null" ]; then
    current_dec=$(printf "%d\n" "$current_hex")
    if [ "$current_dec" -ne "$last_block" ]; then
      if [ "$last_block" -ne 0 ]; then
        delta=$((current_dec - last_block))
        echo "[+] BLOCK UPDATE DETECTED | Block: $current_dec | Jump: +$delta blocks" >> pipeline.log
      else
        echo "[*] Pipeline Synced | Current Block: $current_dec" >> pipeline.log
      fi
      last_block=$current_dec
    fi
  fi
  sleep 2
done
