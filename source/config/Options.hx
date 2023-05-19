package config;

import openfl.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.ds.StringMap;
import ui.CheckboxThingie;
import ui.TextMenuItem;
import ui.TextMenuList;

class Preferences extends ui.Page
{
	public static var preferences:StringMap<Dynamic> = new StringMap<Dynamic>();

	var checkboxes:Array<ui.CheckboxThingie> = [];
	var menuCamera:FlxCamera;
	var items:ui.TextMenuList;
	var camFollow:FlxObject;

	#if debug
	public static var developer_mode:Bool = true;
	#else
	public static var developer_mode:Bool = false;
	#end	

	var descriptionTxt:FlxText;
	var descriptionBG:FlxSprite;

	override public function new()
	{
		super();

		menuCamera = new FlxCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = FlxColor.TRANSPARENT;
		camera = menuCamera;

		add(items = new ui.TextMenuList());
		createPrefItem('ghost tapping', 'gt', 'Give the player a miss penalty for tapping with no hittable notes', false);
		createPrefItem('glow opponent strums', 'dadstrums', 'Give a glow effect when the opponent hits a note like the player', false);
		createPrefItem('notesplashes', 'notesplash', 'Shows notesplashes when you hit a SICK!', false);
		createPrefItem('show accuracy', 'accuracy', 'Displays information on how well you are playing.', false);
		//createPrefItem('alt icon bounce', 'icon-bounce', 'Alternative icon bounce.', false);
		createPrefItem('miss sounds', 'miss', 'Plays the miss sounds when enabled', false);
		createPrefItem('auto pause', 'auto-pause', 'If the game should pause when you focus out of it.', false);
		createPrefItem('colored healthbar', 'colored-bar', 'Allows the game to have custom healthbar colors for characters.', false);
		createPrefItem('health gain on hold notes', 'health-gain', 'Allows you to gain more health with hold notes.', false);
		//createPrefItem('shaders', 'shaders', 'Pretty self explanitory when you enable this.', false);

		descriptionTxt = new FlxText(0, FlxG.height * 0.85, 0, "", 32);
		descriptionTxt.setFormat(Paths.defaultFont, 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		descriptionTxt.borderSize = 2;
		descriptionTxt.scrollFactor.set();
		descriptionTxt.text = items.members[items.selectedIndex].description;

		descriptionBG = new FlxSprite(0, FlxG.height * 0.85).makeGraphic(Math.floor(descriptionTxt.width + 16), Math.floor(descriptionTxt.height + 8), 0xFF000000);
		descriptionBG.alpha = 0.4;
		descriptionBG.scrollFactor.set();
		descriptionBG.y = descriptionTxt.y - 4;
		descriptionBG.screenCenter(X);
		add(descriptionBG);
		add(descriptionTxt);

		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (items != null)
		{
			camFollow.y = items.members[items.selectedIndex].y;
		}
		menuCamera.follow(camFollow, null, 0.06);
		menuCamera.deadzone.set(0, 160, menuCamera.width, 40);
		menuCamera.minScrollY = 0;
		items.onChange.add(function(item:TextMenuItem)
		{
			camFollow.y = item.y;
		});
		menuCamera.maxScrollY = items.members[items.length - 1].y + items.members[items.length - 1].height + 16;

		onExit.add(config.Settings.save);
	}

	public static function getPref(pref:String)
	{
		return preferences.get(pref);
	}

	public static function initPrefs()
	{
		preferenceCheck('accuracy', true);
		preferenceCheck('miss', false);
		preferenceCheck('gt', true);
		//preferenceCheck('icon-bounce', false);
		preferenceCheck('health-gain', true);
		preferenceCheck('dadstrums', true);
		preferenceCheck('notesplash', true);
		preferenceCheck('auto-pause', true);
		preferenceCheck('colored-bar', false);
		preferenceCheck('shaders', true);

		if (!getPref('display'))
			{
				Lib.current.stage.removeChild(Main.fpsCounter);
			}
		FlxG.autoPause = getPref('auto-pause');
		config.Settings.init();
	}

	public static function preferenceCheck(identifier:String, defaultValue:Dynamic)
	{
		if (preferences.get(identifier) == null)
			preferences.set(identifier, defaultValue);
	}

	public function createPrefItem(label:String, identifier:String, description:String, value:Dynamic)
	{
		items.createItem(120, 120 * items.length + 30, label, Bold, function()
		{
			preferenceCheck(identifier, value);
			if (Type.typeof(value) == TBool)
			{
				prefToggle(identifier);
			}
			else
			{
				trace('swag');
			}
		});
		items.members[items.length - 1].description = description;
		if (Type.typeof(value) == TBool)
		{
			createCheckbox(identifier);
		}
	}

	public function createCheckbox(identifier:String)
	{
		var box:ui.CheckboxThingie = new ui.CheckboxThingie(0, 120 * (items.length - 1), preferences.get(identifier));
		checkboxes.push(box);
		add(box);
	}

	public function prefToggle(identifier:String)
		{
			var value:Bool = preferences.get(identifier);
			value = !value;
			preferences.set(identifier, value);
			checkboxes[items.selectedIndex].daValue = value;
			trace('toggled? ' + Std.string(preferences.get(identifier)));
			switch (identifier)
			{
				case 'auto-pause':
					FlxG.autoPause = getPref('auto-pause');
				case 'display':
					if (getPref('display'))
						Lib.current.stage.addChild(Main.memoryCounter);
					else
						Lib.current.stage.removeChild(Main.memoryCounter);					
			}
		}		

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		menuCamera.followLerp = game.CoolUtil.camLerpShit(0.05, FlxG.updateFramerate);
		items.forEach(function(item:ui.MenuItem)
		{
			if (item == items.members[items.selectedIndex])
				item.x = 150;
			else
				item.x = 120;
		});
		changeDescTxt(items.members[items.selectedIndex].description);

		descriptionTxt.screenCenter(X);

		descriptionBG.setPosition(
			game.CoolUtil.coolLerp(descriptionBG.x, descriptionTxt.x - 8, elapsed * 10.65), 
			game.CoolUtil.coolLerp(descriptionBG.y, descriptionTxt.y - 4, elapsed * 10.65)
		);
		descriptionBG.setGraphicSize(
			Math.floor(game.CoolUtil.coolLerp(descriptionBG.width, descriptionTxt.width + 16, elapsed * 10.65)), 
			Math.floor(game.CoolUtil.coolLerp(descriptionBG.height, descriptionTxt.height + 8, elapsed * 10.65))
		);
		descriptionBG.updateHitbox();
		descriptionBG.x = descriptionTxt.getGraphicMidpoint().x - (descriptionBG.width / 2);
	}

	function changeDescTxt(text:String)
	{
		descriptionTxt.fieldWidth = 0;
		descriptionTxt.text = text;
		descriptionTxt.fieldWidth = Math.min(descriptionTxt.width, FlxG.width / 1.5);
		descriptionTxt.updateHitbox();
	}
}