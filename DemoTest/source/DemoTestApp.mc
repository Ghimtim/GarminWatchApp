import Toybox.Application;
import Toybox.System;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Position;
import Toybox.Timer;
import Toybox.Time.Gregorian;

class CommListener extends Communications.ConnectionListener
{
    function initialize()
    {
        Communications.ConnectionListener.initialize();
    }

    public function onComplete()
    {
        // print("Transmit complete");
    }

    public function onError()
    {
        // print("Transmit error");
    }
}

var _view;

var count = 0;

class DemoTestApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        Communications.registerForPhoneAppMessages(method(:onReceive));
        Communications.transmit("First Hello", null, new CommListener());
        startGPS();
        startTimer();
        print("app init");
    }

    public function onReceive(msg)
    {
        System.println(Lang.format("data: $1$", [msg.data.toString()]));
        Communications.transmit(msg.data.toString(), null, new CommListener());
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
        print("app stop");
    }
    
    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        _view = new DemoTestView();
        return [ _view, new DemoTestDelegate() ] as Array<Views or InputDelegates>;
    }

    function timeCallback() {
        print("count: " + count);
        Communications.transmit("count: " + count, null, new CommListener());
        _view.updateCount(count);
        count = 0;
    }

    function startTimer() {
        var timer = new Timer.Timer();
        timer.start(method(:timeCallback), 60000, true);
    }

function startGPS() {
    print("startGPS!");
    Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
}

function onPosition(info) {
        // var str = "";
        // if(info has :when && info.when != null) {
        //     var moment = info.when;
        //     var timeInfo = Gregorian.utcInfo(moment, Time.FORMAT_SHORT);
        //     str = str + Lang.format("time: $1$-$2$-$3$ $4$:$5$:$6$", 
        //     [timeInfo.year.format("%04u"), timeInfo.month.format("%02u"), 
        //     timeInfo.day.format("%02u"), timeInfo.hour, timeInfo.min.format("%02u"), timeInfo.sec.format("%02u")]);
        // }
        var location = info.position.toDegrees();
        var str = Lang.format(" | onPosition: $1$ | $2$",[location[0], location[1]]);

        if(info has :accuracy && info.accuracy != null) {
            var accuracy = info.accuracy;
            str = str + Lang.format(" | accuracy: $1$",[accuracy]);
        }
        
        if(info has :altitude && info.altitude != null) {
            var altitude = info.altitude;
            str = str + Lang.format(" | altitude: $1$",[altitude]);
        }

        if(info has :speed && info.speed != null) {
            var speed = info.speed;
            str = str + Lang.format(" | speed: $1$",[speed]);
        }
        print(str);
        Communications.transmit(str, null, new CommListener());
        count += 1;
        // print(Lang.format("time: $1$-$2$-$3$ $4$:$5$ | accuracy: $6$ | altitude : $7$ | heading : $8$ | latitude : $9$ | longitude : $10$ | speed : $11$", [moment.year.format("%04u"), moment.month.format("%02u"), moment.day.format("%02u"), moment.hour, moment.min.format("%02u"), info.accuracy, info.altitude, info.heading, location[0], location[1], info.speed]));
        _view.updateModel();
    }

}

function getApp() as DemoTestApp {
    return Application.getApp() as DemoTestApp;
}

function stopGPS() {
    Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
}

function print(msg) {
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour, clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);
    System.println(Lang.format("$1$|$2$", [timeString, msg]));
}