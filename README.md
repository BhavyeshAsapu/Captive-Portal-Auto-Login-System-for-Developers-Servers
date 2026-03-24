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
