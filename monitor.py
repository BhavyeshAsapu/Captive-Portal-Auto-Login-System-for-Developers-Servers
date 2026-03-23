import subprocess
import requests
import time
import webbrowser

HOSTEL_SSID = "KLEF"   # CHANGE THIS
CAPTIVE_DOMAIN = "captiveportal.kluniversity.in"
PORTAL_URL = "https://captiveportal.kluniversity.in:8090/httpclient.html"

TEST_URL = "http://clients3.google.com/generate_204"

CHECK_INTERVAL = 120  # 2 minutes


def get_connected_ssid():
    try:
        output = subprocess.check_output(
            "netsh wlan show interfaces",
            shell=True
        ).decode()

        for line in output.split("\n"):
            if "SSID" in line and "BSSID" not in line:
                return line.split(":")[1].strip()

    except:
        return None

    return None


def connect_wifi():
    print("Connecting to hostel WiFi...")
    subprocess.call(
        f'netsh wlan connect name="{HOSTEL_SSID}"',
        shell=True
    )


def is_captive_logged_out():
    try:
        response = requests.get(TEST_URL, timeout=5)

        if CAPTIVE_DOMAIN in response.url:
            return True

        if response.status_code != 204:
            return True

        return False

    except:
        return True


def main():
    print("Starting Smart WiFi Monitor...")

    while True:
        ssid = get_connected_ssid()

        if ssid != HOSTEL_SSID:
            print("Not connected to hostel WiFi.")
            connect_wifi()
            time.sleep(15)

        else:
            print("Connected to hostel WiFi.")

            if is_captive_logged_out():
                print("Captive portal login required.")
                webbrowser.open(PORTAL_URL)
                time.sleep(60)
            else:
                print("Internet authenticated.")

        print("Sleeping...\n")
        time.sleep(CHECK_INTERVAL)


if __name__ == "__main__":
    main()