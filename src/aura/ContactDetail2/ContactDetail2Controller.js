({
	checkMethod : function(component, event, helper) {
        /*var script = document.createElement( 'script' );
        script.onload = function () {
            jQuery.noConflict( true ); //remove this and image load fails
        };*/
        console.log(!window.jQuery);
        if(!window.jQuery){
            var htmlHead = document.getElementsByTagName('head')[0];
        
            //Create Script Tag
            var scriptTag = document.createElement('script');
            //Add Source of Script
            var source = '/resource/jquery1';
            
            //Set Attributes 
            scriptTag.setAttribute("type", "text/javascript");
            scriptTag.setAttribute("src", source);
            
            //Insert Script Dynamically 
            htmlHead.appendChild(scriptTag);
            scriptTag.onload = function () {
                jQuery.noConflict(); //remove this and image load fails
                console.log('check method ' + jQuery.fn.jquery);
            };
		}
        
	},
    
    
    
})