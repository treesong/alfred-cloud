function run(argv) {
	var app = Application.currentApplication()
	app.includeStandardAdditions = true
 
	var result = app.displayDialog("Please input command content", {
		defaultAnswer: "#\n#\n",
		buttons: ["OK","Cancel"],
		defaultButton: "OK",
		hiddenAnswer: false
	});

	if (result.buttonReturned=="OK") {
		return result.textReturned;
	} else {
		return '';
	}
}