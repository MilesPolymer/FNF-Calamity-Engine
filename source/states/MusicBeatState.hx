package states;

//import polymod.Polymod;
import flixel.system.FlxSound;
import game.Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):config.Controls;

	inline function get_controls():config.Controls
		return config.PlayerSettings.player1.controls;

	override public function new()
		{
			//Polymod.clearCache();
	
			FlxG.sound.list.forEachDead(function(sound:FlxSound) {
				FlxG.sound.list.remove(sound, true);
				sound.stop();
				sound.kill();
				sound.destroy();
			});
	
			super();
		}
	

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep >= 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	public static function switchState(nextState:FlxState)
		{
			FlxG.switchState(nextState);
		}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...game.Conductor.bpmChangeMap.length)
		{
			if (game.Conductor.songPosition >= game.Conductor.bpmChangeMap[i].songTime)
				lastChange = game.Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((game.Conductor.songPosition - lastChange.songTime) / game.Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
