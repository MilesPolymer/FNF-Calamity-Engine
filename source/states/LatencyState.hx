package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class LatencyState extends FlxState
{
	var offsetText:FlxText;
	var noteGrp:FlxTypedGroup<game.Note>;
	var strumLine:FlxSprite;

	override function create()
	{
		FlxG.sound.playMusic(Paths.sound('soundTest'));

		noteGrp = new FlxTypedGroup<game.Note>();
		add(noteGrp);

		for (i in 0...32)
		{
			var note:game.Note = new game.Note(game.Conductor.crochet * i, 1);
			noteGrp.add(note);
		}

		offsetText = new FlxText();
		offsetText.screenCenter();
		add(offsetText);

		strumLine = new FlxSprite(FlxG.width / 2, 100).makeGraphic(FlxG.width, 5);
		add(strumLine);

		game.Conductor.changeBPM(120);

		super.create();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + game.Conductor.offset + "ms";

		game.Conductor.songPosition = FlxG.sound.music.time - game.Conductor.offset;

		var multiply:Float = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
			game.Conductor.offset += 1 * multiply;
		if (FlxG.keys.justPressed.LEFT)
			game.Conductor.offset -= 1 * multiply;

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();

			FlxG.resetState();
		}

		noteGrp.forEach(function(daNote:game.Note)
		{
			daNote.y = (strumLine.y - (game.Conductor.songPosition - daNote.strumTime) * 0.45);
			daNote.x = strumLine.x + 30;

			if (daNote.y < strumLine.y)
				daNote.kill();
		});

		super.update(elapsed);
	}
}
