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

```id="arch123"
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

## 📌 Key Features

* 🔁 Continuous WiFi monitoring
* 📡 Auto-reconnect to preferred network
* 🌐 Captive portal detection using HTTP 204 trick
* ⚡ Zero-click login via Chrome extension
* 📴 Auto-close login tab
* 🧩 Lightweight & modular

---

## 🏗️ Project Structure

```id="struct456"
smart-captive-login/
│
├── chrome-extension/
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

```bash id="cmd1"
pip install -r requirements.txt
```

---

### 2️⃣ Configure WiFi Monitor

Edit `wifi_monitor.py`:

```python id="cfg1"
HOSTEL_SSID = "YOUR_WIFI_NAME"
CAPTIVE_DOMAIN = "portal.domain.com"
PORTAL_URL = "https://portal.login.page"
```

---

### 3️⃣ Setup Chrome Extension

* Go to: `chrome://extensions/`
* Enable **Developer Mode**
* Click **Load Unpacked**
* Select `chrome-extension/`

---

### 4️⃣ Add Credentials

Update `script.js`:

```javascript id="cfg2"
chrome.runtime.sendMessage({
    type: "LOGIN",
    user: "YOUR_USERNAME",
    password: "YOUR_PASSWORD",
    closeTab: true
});
```

---

### ▶️ Run the System

```bash id="cmd2"
python wifi_monitor.py
```

---

## 🧠 Detection Logic

Uses:

```id="logic123"
http://clients3.google.com/generate_204
```

* ✅ 204 → Internet working
* 🔁 Redirect → Captive portal active

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
* Credentials stored in plain text (can be improved)

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

## 🏆 Why This Project Matters

This is a **real-world problem-solving project** that demonstrates:

* System automation
* Networking concepts
* Browser extension development
* Cross-tool integration (Python + Chrome APIs)

Perfect for:

* 💼 Resume projects
* 🧑‍💻 Dev productivity tools
* 🧠 Practical engineering skills

---

## 📜 License

//MIT License

---

## 👨‍💻 Author

Built for developers tired of logging into WiFi again and again 😄

-By Bhavvi 
