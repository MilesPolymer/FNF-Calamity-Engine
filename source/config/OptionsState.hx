package config;

import flixel.FlxG;
import flixel.FlxSprite;
import haxe.ds.EnumValueMap;
import config.Preferences;
import config.UIShit;
import config.Accessibility;
import config.ControlsMenu;
class OptionsState extends states.MusicBeatState
{
	public static var fromPlayState:Bool = false;
	public var pages:EnumValueMap<ui.PageName, ui.Page> = new EnumValueMap();
	public var currentName:ui.PageName = Options;
	public var currentPage(get, never):ui.Page;

	inline function get_currentPage()
		return pages.get(currentName);

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/menuDesat'));
		bg.color = 0xFF4E1AAE;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		add(bg);
		var optionsMenu:OptionsMenu = addPage(Options, new config.OptionsMenu(false));
		var preferencesMenu:Preferences = addPage(Preferences, new Preferences());
		var uiMenu:UIShit = addPage(Ui, new UIShit());
		var accessibilityMenu:Accessibility = addPage(Accessibility, new Accessibility());
		var controlsMenu:ControlsMenu = addPage(Controls, new ControlsMenu());
		var categoryMenu:config.PreferencesCategory = addPage(Category, new config.PreferencesCategory());
		if (optionsMenu.hasMultipleOptions())
		{
			optionsMenu.onExit.add(exitToMainMenu);
			controlsMenu.onExit.add(function()
			{
				switchPage(Options);
			});
			preferencesMenu.onExit.add(function()
			{
				switchPage(Category);
			});
			uiMenu.onExit.add(function()
			{
				switchPage(Category);
			});		
			accessibilityMenu.onExit.add(function()
			{
				switchPage(Category);
			});						
		}
		else
		{
			controlsMenu.onExit.add(exitToMainMenu);
			setPage(Controls);
		}
		currentPage.enabled = false;
		super.create();
	}

	function addPage(name:ui.PageName, page:ui.Page):Dynamic
	{
		page.onSwitch.add(switchPage);
		pages.set(name, page);
		add(page);
		page.exists = name == currentName;
		return page;
	}

	function setPage(name:ui.PageName)
	{
		if (pages.exists(currentName))
		{
			currentPage.exists = false;
		}
		currentName = name;
		if (pages.exists(currentName))
		{
			currentPage.exists = true;
		}
	}

	override function finishTransIn()
	{
		super.finishTransIn();
		currentPage.enabled = true;
	}

	function switchPage(name:ui.PageName)
	{
		setPage(name);
	}

	function exitToMainMenu()
		{
			currentPage.enabled = false;
			if (fromPlayState)
				FlxG.switchState(new states.PlayState());
			else
				FlxG.switchState(new states.MainMenuState());
			fromPlayState = false;
		}
}