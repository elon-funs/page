$(".coderead").click(function(){
	var codetxt = $(".coderead>code").html();
	window.prompt("Press Ctrl+C to Copy", codetxt);

});