---
title: batzconverter – A multiple timezone converter
author: chmouel
date: 2021-01-31T16:42:14+00:00
url: /2021/01/31/batzconverter-a-multiple-timezone-converter/
---
I do write a lot of scripts to automate my day to day workflow, some of them I just wrote for 3h to save me 5mn time only once and some others I write in about 5mn but save me hours and hour of productivity.

The script showed today, that I am proud of because of its usefulness and probably not of its code, is called **"batzconverter"** available on <https://github.com/chmouel/batzconverter>. What the script is trying to solve is when you work with your team spread around 3/4 timezones, how do you schedule a meeting easily.

It's a ~200 lines simple shell script that leverage onto the very powerful [GNU date](https://man7.org/linux/man-pages/man1/date.1.html)

In its most simple form when you type the command **batz** you are getting this :

![](/wp-content/uploads/2021/01/image-3.png)

This is showing all timezones (which you can configure) at current time, with some easily identified emojis. The &#x1f3e0; emoji on the right is to show the location of the user.

But you can do way more, let's say you want to show all timezone for tomorrow 13h00 meeting :
![](/wp-content/uploads/2021/01/image-4.png)

It will just do that and show it.

Same goes for a specific date :
![](/wp-content/uploads/2021/01/image-5.png)

You can do some extra stuff, like adding quickly another timezone that isn't configured :
![](/wp-content/uploads/2021/01/image-6.png)

Or give another timezone as the base for conversion, the airplane emoji &#x2708;&#xfe0f; here is to let know that you showing another target timezone : ![](/wp-content/uploads/2021/01/image-7.png)

easy peasy to use, no frills, no bells just usefulness...

There is another flag called "-j" to allow you to output to json, it was
implemented for being able to plug into the awesome [alfredapps](https://www.alfredapp.com/) on osx as a
[workflow](https://www.alfredapp.com/workflows/) :

![](/wp-content/uploads/2021/01/image-9-1024x499.png)

But it doesn't have to be for Alfred, the json outut can be used for any other integrations.

Configuration is pretty simple you just need to configure the timezone you would like to have in a file located _~/.config_ and the emojis associated with it (cause visuals are important! insert rolled eyes emoji here).

Head up on github
[chmouel/batzconverter](https://github.com/chmouel/batzconverter) to learn how
to install and configure it, and feel free to let me know about suggestions or
issues you have using it.
