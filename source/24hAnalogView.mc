import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Application;
import Toybox.Activity;
import Toybox.ActivityMonitor;

enum HandSize {
    small = 1,
    medium,
    large
}

class _24hAnalogView extends WatchUi.WatchFace {
    private var _centerX;
    private var _centerY;
    private var _radiusHour;
    private var _radiusMinute;
    private var _radiusSecond;
    private var _inSleepMode;
    private var _hourHandColor;
    private var _minuteHandColor;
    private var _secondHandColor;
    private var _handSize;
    
    // Heart rate display properties
    private var _showHeartRate;
    private var _heartRateColor;
    private var _lastHeartRate;
    private var _heartRateY;
    
    function initialize() {
        WatchFace.initialize();
        _inSleepMode = false;
        _lastHeartRate = null;
        loadSettings();
    }

    // Load settings from app storage
    function loadSettings() {
        _hourHandColor = Application.Properties.getValue("hourHandColor") as Number;
        _minuteHandColor = Application.Properties.getValue("minuteHandColor") as Number;
        _secondHandColor = Application.Properties.getValue("secondHandColor") as Number;
        _handSize = Application.Properties.getValue("handSize") as HandSize;
        _showHeartRate = Application.Properties.getValue("showHeartRate") as Boolean;
        _heartRateColor = Application.Properties.getValue("heartRateColor") as Number;
        
        // Set defaults if settings are not available
        if (_hourHandColor == null) { _hourHandColor = Graphics.COLOR_RED; }
        if (_minuteHandColor == null) { _minuteHandColor = Graphics.COLOR_WHITE; }
        if (_secondHandColor == null) { _secondHandColor = Graphics.COLOR_YELLOW; }
        if (_handSize == null) { _handSize = small; }
        if (_showHeartRate == null) { _showHeartRate = true; }
        if (_heartRateColor == null) { _heartRateColor = Graphics.COLOR_RED; }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // Get the screen dimensions
        _centerX = dc.getWidth() / 2;
        _centerY = dc.getHeight() / 2;
        
        // Set the radius for the hour and minute hands
        // Hour hand will be shorter than minute hand
        _radiusHour = (dc.getWidth() * 0.32).toNumber();
        _radiusMinute = (dc.getWidth() * 0.5).toNumber();
        _radiusSecond = (dc.getWidth() * 0.45).toNumber();
        
        // Position heart rate text in the bottom portion of the watch face
        _heartRateY = _centerY + (_centerY * 0.3);
    }

    // Called when this View is brought to the foreground
    function onShow() as Void {
        loadSettings();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Clear the screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        // Draw the watch face background and hour markers
        drawWatchFace(dc);
        
        // Get the current time
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;
        var second = clockTime.sec;
        
        // Draw the hands
        drawHands(dc, hour, minute, second);
        
        // Draw heart rate if enabled and not in sleep mode
        if (_showHeartRate && !_inSleepMode) {
            drawHeartRate(dc);
        }
    }
    
    // Draw the watch face with 24-hour markers
    function drawWatchFace(dc as Dc) as Void {
        // Set colors for the watch face
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Draw outer circle
        // dc.setPenWidth(2);
        // dc.drawCircle(_centerX, _centerY, _radiusMinute + 10);
        
        // Draw hour markers
        dc.setPenWidth(2);
        var outerRadius = _radiusMinute;
        var innerRadius = _radiusMinute - 5;
        
        for (var i = 0; i < 24; i++) {
            // Calculate angle for each hour (in radians)
            // For 24-hour, each hour is 15 degrees (24 hours * 15 = 360 degrees)
            var angle = (i * 15) * Math.PI / 180;
            
            // Calculate start and end points for the hour marker
            var outerX = _centerX + outerRadius * Math.sin(angle);
            var outerY = _centerY - outerRadius * Math.cos(angle);
            var innerX = _centerX + innerRadius * Math.sin(angle);
            var innerY = _centerY - innerRadius * Math.cos(angle);
            
            // Draw the hour marker
            dc.drawLine(outerX, outerY, innerX, innerY);
            
            // Add numbers for all hours (0 to 23)
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            var textRadius = innerRadius - 15;
            var textX = _centerX + textRadius * Math.sin(angle);
            var textY = _centerY - textRadius * Math.cos(angle);
            
            dc.drawText(textX, textY, Graphics.FONT_XTINY, i.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
    
    // Draw the hour, minute, and second hands
    function drawHands(dc as Dc, hour as Number, minute as Number, second as Number) as Void {
        // Calculate angles for hour and minute hands
        // For 24-hour dial, hour hand makes one complete revolution (360°) per day
        // Hour angle: each hour is 15° (360 / 24), and each minute adds 15/60 = 0.25°
        var hourAngle = ((hour * 15) + (minute * 0.25)) * Math.PI / 180;
        
        // Minute angle: each minute is 6° (360 / 60)
        var minuteAngle = minute * 6 * Math.PI / 180;
        
        // Calculate endpoints of the hands
        var hourHandX = _centerX + _radiusHour * Math.sin(hourAngle);
        var hourHandY = _centerY - _radiusHour * Math.cos(hourAngle);
        var minuteHandX = _centerX + _radiusMinute * Math.sin(minuteAngle);
        var minuteHandY = _centerY - _radiusMinute * Math.cos(minuteAngle);
        
        // Calculate widths based on hand size setting
        var hourHandWidth = 6;
        var minuteHandWidth = 5;
        var secondHandWidth = 2;
        var centerCircleRadius = 4;
        
        if (_handSize.equals(medium)) {
            hourHandWidth *= 1.5;
            minuteHandWidth *= 1.5;
            secondHandWidth *= 1.5;
            centerCircleRadius *= 1.5;
        } else if (_handSize.equals(large)) {
            hourHandWidth *= 3;
            minuteHandWidth *= 3;
            secondHandWidth *= 3;
            centerCircleRadius *= 3;
        }
        
        // Draw the hour hand
        dc.setColor(_hourHandColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(hourHandWidth);
        dc.drawLine(_centerX, _centerY, hourHandX, hourHandY);
        
        // Draw the minute hand
        dc.setColor(_minuteHandColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(minuteHandWidth);
        dc.drawLine(_centerX, _centerY, minuteHandX, minuteHandY);
        
        // Draw the second hand only if not in sleep mode
        if (!_inSleepMode) {
            // Second angle: each second is 6° (360 / 60)
            var secondAngle = second * 6 * Math.PI / 180;
            var secondHandX = _centerX + _radiusSecond * Math.sin(secondAngle);
            var secondHandY = _centerY - _radiusSecond * Math.cos(secondAngle);
            
            dc.setColor(_secondHandColor, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(secondHandWidth);
            dc.drawLine(_centerX, _centerY, secondHandX, secondHandY);
        }
        
        // Draw center circle
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillCircle(_centerX, _centerY, centerCircleRadius);
    }

    // Get current heart rate data
    function getHeartRate() as Number? {
        var heartRate = null;
        var activityInfo = Activity.getActivityInfo();
        
        if (activityInfo != null && activityInfo.currentHeartRate != null) {
            // Use current heart rate if available from ongoing activity
            heartRate = activityInfo.currentHeartRate;
        } else {
            // Otherwise try to get the latest heart rate from the monitor
            var sample = ActivityMonitor.getHeartRateHistory(1, true).next();
            if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                heartRate = sample.heartRate;
            }
        }
        
        return heartRate;
    }
    
    // Draw heart rate on the watch face
    function drawHeartRate(dc as Dc) as Void {
        // Try to get current heart rate
        var currentHeartRate = getHeartRate();
        
        // Update stored heart rate if we got a valid value
        if (currentHeartRate != null) {
            _lastHeartRate = currentHeartRate;
        }
        
        // Draw heart rate if we have a value
        if (_lastHeartRate != null) {
            dc.setColor(_heartRateColor, Graphics.COLOR_TRANSPARENT);
            
            // Draw heart symbol and heart rate
            var hrText = _lastHeartRate.toString();
            var heartSymbol = "♥ "; // Heart symbol followed by a space
            dc.drawText(_centerX, _heartRateY, Graphics.FONT_MEDIUM, heartSymbol + hrText, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen
    function onHide() as Void {
    }

    // The user has just looked at their watch
    function onExitSleep() as Void {
        _inSleepMode = false;
        WatchUi.requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates
    function onEnterSleep() as Void {
        _inSleepMode = true;
        WatchUi.requestUpdate();
    }
}
