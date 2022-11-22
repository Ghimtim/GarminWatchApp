import Toybox.Lang;
import Toybox.WatchUi;

class DemoTestDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new DemoTestMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}