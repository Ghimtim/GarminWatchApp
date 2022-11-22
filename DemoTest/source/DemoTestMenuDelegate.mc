import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DemoTestMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            print("item 1");
        } else if (item == :item_2) {
            print("item 2");
        }
    }

}