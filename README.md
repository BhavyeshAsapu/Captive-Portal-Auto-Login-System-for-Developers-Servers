# 🚀 Captive Portal Auto Login System for Developers & Servers

> Never let captive portals kill your servers again ⚡

This project provides an automated solution to handle **WiFi captive portal authentication**, making it ideal for:

* 🏫 Hostel networks
* 🏢 Office WiFi
* 🌐 Public networks with login pages

It ensures uninterrupted connectivity for:

* 🖥️ Local development servers
* 🌍 Self-hosted services
* 🤖 Bots & automation scripts
* 📡 IoT / edge devices

---

## ❗ Problem

Captive portals require **manual login**, which causes:

* ❌ Server downtime after disconnects
* ❌ Broken APIs / webhooks
* ❌ Interrupted deployments
* ❌ Manual re-login frustration

---

## ✅ Solution

This system combines:

### 🧠 Python WiFi Monitor

* Detects WiFi connection
* Verifies internet access
* Opens captive portal when needed

### 🔌 Chrome Extension Auto Login

* Injects credentials
* Submits login automatically
* Optionally closes tab

---

## ⚙️ Architecture

```
          ┌──────────────────────────┐
          │   WiFi Network (SSID)    │
          └────────────┬─────────────┘
                       │
              [Python Monitor]
                       │
     ┌─────────────────┴─────────────────┐
     │                                   │
Check Internet                     Not Authenticated
     │                                   │
     ▼                                   ▼
 Server Runs                    Open Captive Portal
                                      │
                                      ▼
                           [Chrome Extension]
                                      │
                                      ▼
                             Auto Login Success
                                      │
                                      ▼
                              Internet Restored
```

---

## 🖧 Headless Server Mode (NAS / Proxmox / Linux Servers)

For servers without GUI/browser, use the shell script:

```bash
chmod +x server_auto_login.sh
export CAPTIVE_USERNAME="YOUR_USERNAME"
export CAPTIVE_PASSWORD="YOUR_PASSWORD"
./server_auto_login.sh
```

This script:

* Checks connectivity using `http://clients3.google.com/generate_204`
* Detects captive-portal redirects
* Submits credentials with `curl` (no browser required)
* Keeps running in a loop (or once, if configured)

### Optional Environment Variables

```bash
export CAPTIVE_LOGIN_URL="https://captiveportal.kluniversity.in:8090/httpclient.html"
export CAPTIVE_MATCH_DOMAIN="captiveportal.kluniversity.in"
export CAPTIVE_USER_FIELD="username"
export CAPTIVE_PASS_FIELD="password"
export CHECK_INTERVAL=120
export POST_LOGIN_WAIT=8
export CAPTIVE_RUN_ONCE=false
export CAPTIVE_INSECURE_TLS=false
```

### Run as a systemd Service (recommended for always-on servers)

### Recommended Server File Placement

Use this layout on your server so the script is easy to manage:

```text
/opt/captive-portal/server_auto_login.sh                 # executable script
/etc/captive-portal/credentials.env                      # username/password (600)
/etc/systemd/system/captive-portal-autologin.service     # service unit
```

### Deploy and run in background (exact steps)

```bash
# 1) Create app/config folders
sudo install -d -m 755 /opt/captive-portal
sudo install -d -m 700 /etc/captive-portal

# 2) Copy script from this repo to server runtime location
# Replace /path/to/repo with your actual clone path (example: /home/user/captive-portal-autologin)
sudo cp /path/to/repo/server_auto_login.sh /opt/captive-portal/server_auto_login.sh
sudo chmod 755 /opt/captive-portal/server_auto_login.sh

# 3) Create credential file (root-only)
sudo install -m 600 /dev/null /etc/captive-portal/credentials.env
sudo nano /etc/captive-portal/credentials.env
# Add:
# CAPTIVE_USERNAME=YOUR_USERNAME
# CAPTIVE_PASSWORD=YOUR_PASSWORD
```

Create `/etc/systemd/system/captive-portal-autologin.service`:

```ini
[Unit]
Description=Captive Portal Auto Login
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile=/etc/captive-portal/credentials.env
WorkingDirectory=/opt/captive-portal
ExecStart=/opt/captive-portal/server_auto_login.sh
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Then enable it:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now captive-portal-autologin.service
sudo systemctl status captive-portal-autologin.service
sudo systemctl is-enabled captive-portal-autologin.service
```

Useful checks:

```bash
# Live logs
sudo journalctl -u captive-portal-autologin.service -f

# Verify service survives reboot
sudo reboot
# after login:
sudo systemctl status captive-portal-autologin.service
```

---

## 📌 Key Features

* 🔁 Continuous WiFi monitoring
* 📡 Auto-reconnect to preferred network
* 🌐 Captive portal detection using HTTP 204 trick
* ⚡ Zero-click login via Chrome extension
* 📴 Auto-close login tab
* 🧩 Lightweight & modular

---

## 🏗️ Project Structure

```
smart-captive-login/
│
├── chrome-extension/   # ⚠️ Must be loaded manually in browser
│   ├── manifest.json
│   ├── background.js
│   └── script.js
│
├── monitor/
│   └── wifi_monitor.py
│
├── requirements.txt
└── README.md
```

---

## 🖥️ Setup Guide

### 1️⃣ Install Python Dependencies

```bash
pip install -r requirements.txt
```

---

### 2️⃣ Configure WiFi Monitor

Edit `wifi_monitor.py`:

```python
HOSTEL_SSID = "YOUR_WIFI_NAME"
CAPTIVE_DOMAIN = "portal.domain.com"
PORTAL_URL = "https://portal.login.page"
```

---

## 🔌 Chrome Extension Installation (Required)

The auto-login module is a **Chrome Extension**, not a normal script.

👉 It must be manually added to your browser.

### 📂 Steps to Install

1. Open Chrome and go to:

   ```
   chrome://extensions/
   ```

2. Enable:

   * ✅ Developer Mode

3. Click:

   * 👉 Load Unpacked

4. Select the folder:

   ```
   chrome-extension/
   ```

---

### ⚠️ Important Notes

* Works only on Chromium-based browsers:

  * Google Chrome ✅
  * Microsoft Edge ✅
  * Brave ✅

* Not supported:

  * Firefox ❌
  * Safari ❌

* Extension must remain **enabled**

---

### 🔑 Add Your Credentials

Edit `script.js`:

```javascript
chrome.runtime.sendMessage({
    type: "LOGIN",
    user: "YOUR_USERNAME",
    password: "YOUR_PASSWORD",
    closeTab: true
});
```

---

### ▶️ Run the System

```bash
python wifi_monitor.py
```

---

## 🧠 Detection Logic

Uses:

```
http://clients3.google.com/generate_204
```

* ✅ 204 → Internet working
* 🔁 Redirect → Captive portal detected

---

## 💡 Real-World Use Cases

### 🖥️ Run Local Servers Without Interruptions

* Node.js / Spring Boot apps
* React dev servers
* Backend APIs

### 🌐 Self-Hosting in Hostels

* Personal dashboards
* Portfolio hosting
* Mini cloud setups

### 🤖 Automation & Bots

* Telegram bots
* Cron jobs
* Scrapers

### 📡 IoT & Edge Devices

* Raspberry Pi setups
* Smart home services

---

## ⚠️ Limitations

* Works best with predictable captive portals
* Requires Chrome (or Chromium-based browser)
* Credentials stored in plain text

---

## 🔐 Security Improvements (Recommended)

* Use `.env` file
* Encrypt credentials
* Add token-based login support

---

## 🚀 Future Enhancements

* 🖥️ Background service (no terminal needed)
* 📊 Dashboard for connection logs
* 🌐 Multi-network support
* 🐧 Linux & macOS WiFi support
* 🔒 Secure credential vault

---

## ⚠️ Disclaimer

This tool is intended for **authorized and personal network use only**.

Do NOT use it on networks where automation or credential injection is prohibited.

---

## 🏆 Why This Project Matters

This is a **real-world problem-solving project** that demonstrates:

* System automation
* Networking concepts
* Browser extension development
* Cross-tool integration (Python + Chrome APIs)

Perfect for:

* 💼 Resume projects
* 🧑‍💻 Developer productivity tools
* 🧠 Practical engineering skills

---

## 📜 License

MIT License

---

## 👨‍💻 Author

Built for developers tired of logging into WiFi again and again 😄

**— Bhavvi**
