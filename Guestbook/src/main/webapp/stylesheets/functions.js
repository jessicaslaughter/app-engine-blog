window.onload = function() {
	var title = document.getElementById("title");
	var content = document.getElementById("content");
}

function validate() {
	if (title.value != "" && content.value != "") {
		return true;
	}
	else {
		return false;
	}
}