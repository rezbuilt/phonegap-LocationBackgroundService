/**
 * rezLocation.js
 *  
 * Phonegap RezLocation Instance plugin
 * Copyright (c) MichaelRzeznik
 *
 */
var RezLocation = function(){};

RezLocation.start = function(types, success, fail) {
    if (!fail) { fail = function() {}}
    
    if (typeof fail != "function")  {
        console.log("Location failure: failure parameter not a function")
        return
    }
    
    if (typeof success != "function") {
        fail("Location failure: success callback parameter must be a function")
        return
    }	
    return Cordova.exec(success, fail, "CDVRezLocation", "print", types);
		  
};
  

cordova.addConstructor(function() {
                       
                       /* shim to work in 1.5 and 1.6  */
                       if (!window.Cordova) {
                       window.Cordova = cordova;
                       };
                       
                       
                       if(!window.plugins) window.plugins = {};
                       window.plugins.locationService = new RezLocation();
                       });