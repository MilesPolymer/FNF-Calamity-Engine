package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	public static var defaultFont = Paths.font("vcr.ttf");

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
		{
			if (library != null)
				return getLibraryPath(file, library);
	
			if (currentLevel != null)
			{
				var levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
	
				levelPath = getLibraryPathForce(file, "shared");
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}
	
			return getPreloadPath(file);
		}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	//inline static public function dialoguetxt(key:String, ?library:String)
	//{
	//	return getPath('$key.txt', TEXT, library);
	//}

	inline static public function hx(key:String, ?library:String)
	{
		return getPath('$key.hx', TEXT, library);
	}	

	inline static public function formatToSongPath(path:String)
		{
			return path.toLowerCase();
		}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	/*inline static public function offsetjson(key:String,?container:String, ?library:String)
	{
		if(container==null)container=key;
		return getPath('data/character-data/offsets/$container/$key.json', TEXT, library);
	}*/	

	inline static public function songjson(key:String,?container:String, ?library:String)
	{
		if(container==null)container=key;
		return getPath('songs/$container/$key.json', TEXT, library);
	}	

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function video(key:String, ?library:String)
	{
		trace('assets/videos/$key.mp4');
		return getPath('videos/$key.mp4', BINARY, library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function imageLoader(key:String, ?library:String)
		{
			return getPath('art/$key.png', IMAGE, library);
		}	

	inline static public function data(key:String, ?library:String)
	{
		return getPath('data/$key.png', IMAGE, library);
	}	

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	/*inline static public function fileExists(key:String, type:AssetType, ?library:String)
	{
		if (OpenFlAssets.exists(getPath(key, type)))
		{
			return true;
		}
		return false;
	}*/

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
		{
			return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
		}

	static public function loadImage(key:String, ?library:String):FlxGraphic
		{
			var path = image(key, library);
	
			#if FEATURE_FILESYSTEM
			if (Caching.bitmapData != null)
			{
				if (Caching.bitmapData.exists(key))
				{
					Debug.logTrace('Loading image from bitmap cache: $key');
					// Get data from cache.
					return Caching.bitmapData.get(key);
				}
			}
			#end
	
			if (OpenFlAssets.exists(path, IMAGE))
			{
				var bitmap = OpenFlAssets.getBitmapData(path);
				return FlxGraphic.fromBitmapData(bitmap);
			}
			else
			{
				trace('Could not find image at path $path');
				return null;
			}
		}	
}