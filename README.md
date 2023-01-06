# UntitledCrawler
## Game Engine
I used the engine called [Godot 3.5.1](https://godotengine.org/article/maintenance-release-godot-3-5-1). It is primearly made for 2D game/app development.
Godot uses a language called gdscript or gd, which is similar to python in many ways. Godot uses a node based child/parent system which is pretty easy to get used to.
## The game
The game belongs to the linear dungeon crawler genre. In other words, it is an exploration game with many rooms and enemies.
This game is a random generation game, the enemies are randomly spawned for every room (There is a preset system).
## Installation
Check [releases](https://github.com/SpyroMF/UntitledCrawler/releases).
## Building the game
1. Install [Godot 3.5.1](https://godotengine.org/article/maintenance-release-godot-3-5-1).
2. Download this repository.
3. Open the project.godot file with the godot program or import it from godot.
4. Click Project > Export
5. Export with the desired settings

# Assessment
## [01] Development
I have developed a working game (That does not look very beutifull) and i have written in gdscript.
There are [one of the scripts](https://github.com/SpyroMF/UntitledCrawler/blob/master/worlds/castle/door/door.gd) which have really good structure (i belive).
Here is a snippet of the start:
```
signal left_door_entered
signal right_door_entered
signal up_door_entered
signal down_door_entered

onready var door_left  = $DoorLeft
onready var door_right = $DoorRight
onready var door_up    = $DoorUp
onready var door_down  = $DoorDown

onready var door_left_hitbox  = $DoorLeft/HB/CS
onready var door_right_hitbox = $DoorRight/HB/CS
onready var door_up_hitbox    = $DoorUp/HB/CS
onready var door_down_hitbox  = $DoorDown/HB/CS
```
## [02] System Development
I have made good use of breaking big tasks into smaller ones. This have released a lot of stress since I started this current project about only a week ago.
Since I didn't have much time; instead of making many enemies I only made one, that have many properties like speed, healt and size. That way i could make a little bossbattle when the player entered room 10 by just making the enemy bigger, have more health and move slower.
I would also say that i used something between the agile and waterfall workflows. I showed off what i had made to get some feedback, and took some suggestions into considiration.
## [03] Documentation
I have made many comments in every script and writing this read me. Most of the helpfull comments are in the [player.gd](https://github.com/SpyroMF/UntitledCrawler/blob/master/player/player.gd) script. Here i explain different kind of confusing functions and such wich are not in python.
## [04] Version Managment
I have used the git plugin with godot, but it had it's problems. In case github and git would fail at any time i had a copy of every different time i worked on the project. There where even one time one of the files got corrupted (Thank god that i had just commited and pushed to github!).
## [05] Databases
So I tried to find out how i connected a database to my godot project, but i found out that i would need to rebuild the whole engine. I tried making my own database system that had the simple CREATE, DELETE and UPDATE functions, but i found out that would be a whole new project in itself.
I opted with a simple .json saving system.
UPDATE: I found a database that might work, but it is too late to do it now. I might check it out later. [LiteDB](http://www.litedb.org/)
## [06] Information Security
I did not find that many instances where i could use information security. I guess you could call .gitignore security (Confidential in the **C** IA). I also think godot trashes pretty much any unused variables. I could not find anything that strengtend the integrity (C **I** A). And my game is pretty accessible (CI **A**)
## [07] Secure Coding
I had have some measures against errors. Specially when [loading a savefile](https://github.com/SpyroMF/UntitledCrawler/blob/master/game.gd).
## [08] Testing and Debugging
I had many errors, and they where more often than not very hard to fix, I used print() all the time to find out what i was doing wrong. (gdscripts error outputs are not that great)

# What went wrong?
### MiSO (Minecraft server manager)
I probably used around a 100 hours on this project. It could easily implement most of the Assessments. I finally was done with the UI, then I found out godot can't run .jar files like batch. But i didn't give up yet, I tried to make one with Python's CLI! Then i gave up... (I wanted a visual application, that would actually be usefull)
### Discord Bot
I wanted to make a discord bot, I started. I lost motivation.
### Flappy Bird 2
I worked pretty hard on this game, it was almost finished. And I lost motivation again...
### UntitledSpaceGame
I wanted to make a 3D game, godot's 3D renderer isnt the best. And i lost motivation even again...
### UntitledCrawler
I was seeing a pattern, and tried to take a christmas break, and here I am now with the biggest project i have worked on... It is sertenly not near somthing i would call a product, but closer to a tech demo.
There where still problems with this project, the door system was not working properly so I ended up throwing away the idea and made 2 doors instead of 4 doors. I could not find a way of implementing databases

### What i take with me to the next time
This was a good way of learning that easier projects might be less impressive, but can also turn out to be a "good" product (it is definatly not a product yet). I need to really find something that motivates me, and make a good plan to follow.
