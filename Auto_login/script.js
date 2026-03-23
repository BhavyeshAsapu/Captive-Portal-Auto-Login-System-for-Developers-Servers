chrome.runtime.sendMessage({
	type: "LOGIN",
	user: "User ID or Username",
	password: "Passwrord",
	closeTab: true
});
