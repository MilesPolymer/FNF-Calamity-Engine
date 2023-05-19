package config;

import flixel.FlxG;
import lime.app.Application;

class Settings
{
    private static var timer:haxe.Timer;
    
    public static var preferences:Map<String, Dynamic> = [];

    public static var uimenu:Map<String, Dynamic> = [];

    public static var accessibility:Map<String, Dynamic> = [];

    public static function init()
    {
        FlxG.save.bind('fizzy-engine', 'NebulaZone');

        if (FlxG.save.data.preferences != null)
            config.Preferences.preferences = FlxG.save.data.preferences;
        if (FlxG.save.data.uimenu != null)
            config.UIShit.uimenu = FlxG.save.data.uimenu;
        if (FlxG.save.data.accessibility != null)
            config.Accessibility.accessibility = FlxG.save.data.accessibility;                   

        Application.current.onExit.add(function(v:Int)
        {
            save();
        });
       
        timer = new haxe.Timer(60000); // in case something goes wrong
        timer.run = save;
    }

    public static function save():Void
    {
        preferences = config.Preferences.preferences;
        FlxG.save.data.preferences = preferences;
        FlxG.save.flush();

        uimenu = config.UIShit.uimenu;
        FlxG.save.data.uimenu = uimenu;
        FlxG.save.flush();
        
        accessibility = config.Accessibility.accessibility;
        FlxG.save.data.accessibility = accessibility;
        FlxG.save.flush();            
    }
}