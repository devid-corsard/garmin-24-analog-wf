import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Lang;

class SettingsMenuView extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Watch Settings"});
        
        addItem(new WatchUi.MenuItem("Hour Hand", null, "hourHand", null));
        addItem(new WatchUi.MenuItem("Minute Hand", null, "minuteHand", null));
        addItem(new WatchUi.MenuItem("Second Hand", null, "secondHand", null));
        addItem(new WatchUi.MenuItem("Hand Size", null, "handSize", null));
    }
}

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }
    
    function onSelect(menuItem as MenuItem) {
        var id = menuItem.getId() as String;
        
        if (id.equals("hourHand") || id.equals("minuteHand") || id.equals("secondHand")) {
            var submenu = buildColorMenu(id);
            WatchUi.pushView(submenu, new ColorMenuDelegate(id), WatchUi.SLIDE_LEFT);
        } else if (id.equals("handSize")) {
            var submenu = buildSizeMenu(id);
            WatchUi.pushView(submenu, new HandSizeMenuDelegate(id), WatchUi.SLIDE_LEFT);
        }
    }
    
    function buildColorMenu(handType as String) {
        var menu = new WatchUi.Menu2({:title=>"Select Color"});
        
        menu.addItem(new WatchUi.MenuItem("Red", null, Graphics.COLOR_RED, null));
        menu.addItem(new WatchUi.MenuItem("DkRed", null, Graphics.COLOR_DK_RED, null));
        menu.addItem(new WatchUi.MenuItem("White", null, Graphics.COLOR_WHITE, null));
        menu.addItem(new WatchUi.MenuItem("Yellow", null, Graphics.COLOR_YELLOW, null));
        menu.addItem(new WatchUi.MenuItem("Green", null, Graphics.COLOR_GREEN, null));
        menu.addItem(new WatchUi.MenuItem("Blue", null, Graphics.COLOR_BLUE, null));
        menu.addItem(new WatchUi.MenuItem("Purple", null, Graphics.COLOR_PURPLE, null));
        menu.addItem(new WatchUi.MenuItem("Pink", null, Graphics.COLOR_PINK, null));
        
        return menu;
    }
    
    function buildSizeMenu(handType as String) {
        var menu = new WatchUi.Menu2({:title=>"Select Size"});
        
        menu.addItem(new WatchUi.MenuItem("Small", null, 1, null));
        menu.addItem(new WatchUi.MenuItem("Medium", null, 2, null));
        menu.addItem(new WatchUi.MenuItem("Large", null, 3, null));
        
        return menu;
    }
}

class ColorMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _handType;
    
    function initialize(handType as String) {
        Menu2InputDelegate.initialize();
        _handType = handType;
    }
    
    function onSelect(menuItem as MenuItem) {
        var colorValue = menuItem.getId() as Number;
        
        if (_handType.equals("hourHand")) {
            Application.Properties.setValue("hourHandColor", colorValue);
        } else if (_handType.equals("minuteHand")) {
            Application.Properties.setValue("minuteHandColor", colorValue);
        } else if (_handType.equals("secondHand")) {
            Application.Properties.setValue("secondHandColor", colorValue);
        }
        
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.requestUpdate();
    }
}

class HandSizeMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    function initialize(handType as String) {
        Menu2InputDelegate.initialize();
    }
    
    function onSelect(menuItem as MenuItem) {
        var sizeValue = menuItem.getId() as Number;
        
        Application.Properties.setValue("handSize", sizeValue);
        
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.requestUpdate();
    }
}
