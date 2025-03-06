import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class _24hAnalogApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        // Initialize default settings if they don't exist
        if (Application.Properties.getValue("hourHandColor") == null) {
            Application.Properties.setValue("hourHandColor", Graphics.COLOR_RED);
        }
        if (Application.Properties.getValue("minuteHandColor") == null) {
            Application.Properties.setValue("minuteHandColor", Graphics.COLOR_WHITE);
        }
        if (Application.Properties.getValue("secondHandColor") == null) {
            Application.Properties.setValue("secondHandColor", Graphics.COLOR_YELLOW);
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new _24hAnalogView() ];
    }
    
    // Handle menu behavior 
    function getSettingsView() {
        return [new SettingsMenuView(), new SettingsMenuDelegate()];
    }
}

function getApp() as _24hAnalogApp {
    return Application.getApp() as _24hAnalogApp;
}