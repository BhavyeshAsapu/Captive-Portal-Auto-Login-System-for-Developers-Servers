chrome.runtime.onMessage.addListener((msg, sender) => {
  if (msg.type === "LOGIN" && sender.tab?.id) {
    const tabId = sender.tab.id;

    chrome.debugger.attach({ tabId }, "1.3", () => {
      if (chrome.runtime.lastError) {
        console.error(chrome.runtime.lastError.message);
        return;
      }

      chrome.debugger.sendCommand(
        { tabId },
        "Runtime.evaluate",
        {
          expression: `
            document.querySelector('#username').value = '${msg.user}';
            document.querySelector('#password').value = '${msg.password}';
            submitRequest();
          `
        }, () => {
		  chrome.debugger.detach({ tabId });

		  if (msg.closeTab) {
		    setTimeout(() => chrome.tabs.remove(tabId), 1000);
		  }
		}
      );
    });
  }
});
