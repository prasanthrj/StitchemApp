

// Event Binding ....

function bindEvent(elementPkey, event, transition, toPage){
    $("#" + elementPkey).bind(event, function(event, ui){
        $.mobile.changePage(toPage, transition);
    });
}
	