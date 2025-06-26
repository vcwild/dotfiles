#!/usr/bin/env bash

expiry_epoch=$(cat ~/.cache/vault_token_expiry 2>/dev/null || echo "")

if [ -n "$expiry_epoch" ]; then
    now_epoch=$(date +%s)
    remaining=$(( expiry_epoch - now_epoch ))

    if [ "$remaining" -gt 0 ]; then
        # Round up hours
        hours=$(( (remaining + 3599) / 3600 ))
        mins=$(( (remaining % 3600) / 60 ))

        if [ "$hours" -ge 1 ]; then
            echo "🔑${hours}h"
        elif [ "$mins" -ge 1 ]; then
            echo "🔑${mins}m"
        else
            echo "🔑<1m"
        fi
    fi
fi
