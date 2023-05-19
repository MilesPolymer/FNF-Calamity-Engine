package states;

import openfl.display.BitmapData;
import openfl.system.System;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.transition.FlxTransitionableState;

import game.Discord.DiscordClient;

using StringTools;

class CreditsState extends states.MusicBeatState // code used from Soft Mod
{
	var selector:FlxText;
	var curSelected:Int = 0;

	private var grpSongs:FlxTypedGroup<ui.Alphabet>;
	private var curPlaying:Bool = false;
	var boolList = StoryMenuState.getLocks();
	
	public static var credits:Array<String> = [
	"Press Enter For Social:",
	'',
	'Fizzy Engine Creator:',
	'NebulaZone',
	'',	
	'Credits in GameBanana:',
	'Kade',
	'Smokey 5',
	'Shadow Mario',
	];

	override function create()
	{
		DiscordClient.changePresence("Credits Menu", null);

		if(!FlxG.sound.music.playing){
			FlxG.sound.playMusic(Paths.music("creditsMenu"));
		}
		
		FlxG.autoPause = false;
	
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/menuOptions'));
		bg.color = 0xFF36007C;
		add(bg);

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		grpSongs = new FlxTypedGroup<ui.Alphabet>();
		add(grpSongs);

		for (i in 0...credits.length)
		{
			var songText:ui.Alphabet = new ui.Alphabet(0, (70 * i) + 30, new EReg('_', 'g').replace(new EReg('0', 'g').replace(credits[i], 'O'), ' '), true, false);
			songText.isMenuItem = true;
			songText.screenCenter(X);
			songText.targetY = i;

			if(credits[i].contains(":")){
				songText.color = 0xFF9900FF;
			}

			grpSongs.add(songText);
		}

		changeSelection();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		var swag:ui.Alphabet = new ui.Alphabet(1, 0, "swag");

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.F)
		{
		FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		
		

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.autoPause = true;
			FlxG.switchState(new states.MainMenuState());
		}

		if (accepted)
		{
			trace(curSelected);
			switch (curSelected){
				case 0:
				case 1:
				case 2:
				case 3:
					FlxG.openURL("https://twitter.com/NebulaZone_");
				case 4:
				case 5:
				case 6:
					FlxG.openURL("https://twitter.com/kade0912");
				case 7:
					FlxG.openURL("https://twitter.com/Smokey_5_");
				case 8:
					FlxG.openURL("https://twitter.com/Shadow_Mario_");
				case 9:
					FlxG.openURL("https://gamebanana.com/members/1813143");
				
				default:
					trace(curSelected);			
			}
		}
	}

	function changeSelection(change:Int = 0)
	{

		curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;

		var changeTest = curSelected;

		if(changeTest == curSelected){
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if(credits[curSelected] == "" || credits[curSelected].contains(":") && credits[curSelected] != "" && credits[curSelected] != "Press Enter For Social:"){
			changeSelection(change == 0 ? 1 : change);
		}		
		

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}

	}
}