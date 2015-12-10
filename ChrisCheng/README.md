## Minecraft Player Tracking

I plan to do a project involving the use of [OpenComputers](http://oc.cil.li/index.php?/page/index.html) - a Minecraft mod that implements LUA-controlled computers - as well as [Computronics](http://wiki.vex.tty.sh/wiki:computronics) - an add-on that adds a Radar block an OpenComputer computer block can control - to track a player's position relative to it over a period of time, such as over a week or two.

While I'll be tracking myself during the time, the completed program could feasibly be configured to track any player, potentially without their knowledge if hidden well.  This project is meant to be a proof-of-concept, showing that such a thing can be done.

Information gathered by a program could be used to generate a heatmap of player positions (for purposes ranging from the beneficial (beacon placement), annoying (advertisement placement) to *downright harmful* (when and where to launch an attack)).  And because OpenComputers implement invisible point-to-point networks via the [Linked Card](http://ocdoc.cil.li/item:linked_card), as well as allowing for HTTP requests or opening TCP connections via the [Internet Card](http://ocdoc.cil.li/item:internet_card), the data could be routed anywhere.  The latter could be additionally bad, because a malicious player could effectively snoop on a person without even logging into the game.

## How to use

First of all, you'll require an instance of Minecraft.  Version 1.7.10, with Minecraft Forge build 1566 installed on top of that.  It'll also require the following mods (at minimum):

* OpenComputers v1.5.20.38+
* AsieLib 0.4.5
* Computronics 1.6.0

Then you'll want to hop into a world that has those three installed.  Craft yourself a computer (or spawn one in if you're managing it) using OC's [getting started guide](http://ocdoc.cil.li/tutorial:oc1_basic_computer) to figure out how to work with the mod.  I'd also suggest installing an Internet Card if you've got the resources for it.

Once your computer's created and loaded with the openOS disk, you can grab the code for the radar application by running ` # wget https://raw.githubusercontent.com/FOSSRIT/Free-Culture-Projects/master/ChrisCheng/radar.lua`
 
If that does not work, chances are you're not able to make HTTP connections.  If that's the case, then you'll need to copy in code from the file.  Enter `# edit radar.lua` and press Insert or the Middle Mouse Button to paste in the code from your clipboard.

Next, you'll need to hook in your Radars.  Craft yourself _at minimum_ four Radars and several bits of Cable.  Place them all down and hook them into the computer hosting the application.  For best results, do **NOT** have them all on the same plane or in a line.

The next step can be expedited a bit if you get yourself an Analyzer - you'll need to take down several 28-character component IDs (and a ctrl-right click on a component with the Analyzer copies the address to your clipboard).  Make a new file next to `radar.lua` called `radars.ids` - this file tells the computer which Radars it's interfacing with, as well as offering a bit more information.  Inside this file, you'll need to put the Radar information down as such (one line per Radar): `<componentAddressOfRadar> <xCoord> <yCoord> <zCoord>`
 
Each coordinate value should be the absolute position of that block in the world (as obtained by F3).  I've had good results from standing on the Radar and using those values (subtracting 1 from the Y coord).  Feel free to put in as many Radars as you want.

Finally, it's only a matter of running the Radar application.  You can run it straight with `# radar`, or with an argument, indicating where to put the log file, with `# radar /usr/path/to/log/file.yes`

## Code from other sources

This project does utilize a modified version of [ghela's trilateration.js code](https://github.com/gheja/trilateration.js/blob/master/trilateration.js), which itself was a JavaScript implementation of the formulas provided on Wikipedia.  Other than that, all code belongs to me (though you're free to do whatever you want with it under the AGPL 3.0, see the LICENSE)