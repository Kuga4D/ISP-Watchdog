# ISP-Watchdog

# ISP-Watchdog: Network Packet Loss Monitor

I built this project to gather hard evidence of network instability and packet loss from my ISP. While originally tested on a Vodafone connection, this setup works for any Internet Service Provider.

## Why I built this:

The original issue was packet loss of up to 21%. After a few weeks of contacting support, they finally sent a technician who diagnosed that the signal was too **weak** at my connection port.

Since I have had long-term issues with this connection, I wanted a way to test the stability over a longer period. That's why I **built** this 24/7 monitor which runs on a Raspberry Pi 4. Every single hiccup and connection loss is recorded and documented.

## How it works:

- **Automation:** A self-hosted **n8n** instance triggers a 20-packet ping test every 5 minutes.
    
- **Dual-Layer Logging:** - **Local:** Results are saved to a local CSV file on the Pi. This acts as a "black box" that remains active even if the internet is completely down.
    
    - **Cloud:** Data is pushed to Google Sheets for real-time visualization and remote monitoring.
        
- **Resilience:** Implemented a retry-logic (4 attempts, 2000ms delay) for cloud uploads to handle transient connection drops.
    
- **Security:** The system is fully secured behind the router firewall with **no open ports**.
    

## Getting n8n to do it all:

The biggest hurdle was making the headless n8n instance accessible and functional within the local network. By default, n8n restricts access to localhost.

I solved this by using **PM2** and a custom `ecosystem.config.js`. This allowed me to:

1. Force n8n to listen to all network interfaces (`0.0.0.0`), making the Web UI accessible via the Pi's local IP.
    
2. Ensure n8n has the permissions to execute system commands (like `ping`).
    
3. Maintain persistence across reboots.
    

## Performance & Evidence:

- **Internal Baseline (90 Minutes):** Before monitoring the ISP, I ran a high-resolution test (1-second intervals) between my PC and the router for 90 minutes. With over 5,000 successful pings, 0.0% loss, and an average latency of 0.28 ms, I confirmed that my local hardware (CAT7 cabling and Router) was not the source of the issues.
    
- **ISP Performance:** The monitor successfully documented external packet loss spikes of up to **10%**, proving the issue was outside my local network.
    

## Repo Structure:

- `Internal-Network-Check.ps1`: The Windows PowerShell script for the internal stress test. The duration of the test is decided by the user. I let it run for 90 minutes.
    
- `Longterm_packetloss_test.json`: The core n8n workflow logic. It handles the 24/7 pings, CSV logging, and Google Sheets export.
    
- `ecosystem.config.js`: The PM2 configuration file. It’s the "instruction manual" that tells the Pi how to run n8n correctly in the background.
    

## A Note on the Process & AI Collaboration:

I believe in transparency. Here’s how I built this:

- **First-timer:** This was my first real-world project using n8n and a headless Raspberry Pi.
    
- **AI-Assisted:** I used AI to speed up the learning process and for deep-dive troubleshooting. While the AI helped me navigate Linux configurations and Regex strings, I personally implemented, tested, and debugged every step on my hardware.
    
- **No Fluff:** I don't use technical terms I don't understand. I now know exactly why `0.0.0.0` was necessary and how the retry-logic protects my data. This project was a massive learning curve in bridging local hardware with cloud automation.
