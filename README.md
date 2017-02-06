# PollutionMonitor-Mac
PollutionMonitor is a status bar app for macOS using [aqicn][1] data to display pollution AQI readings.

This is the source for the app which is available on the Mac App Store here: [https://itunes.apple.com/gb/app/pollution-monitor/id1197195842?mt=12][2] - enjoy!

Just so we're clear, I'm releasing this so you can study it and learn how to make apps (or how not to make them, depending on what you think of my code).

This is not an invitation to take my app and release it unmodified (or mostly unmodified) under your own name. If you do that, I will find you ಠ\_ಠ.

The source is licensed under the [GNU GPLv3][3], which means you can copy the source and even sell apps derived from it, but you have to make available the source code of any programs you sell.

## API Key
You will need to get your own API key, see [here][4] and [here][5].

## Developers
This code sets out a structure for a Mac status bar app that
- makes network requests
- updates its menu items based on network responses
- creates a coloured image tile with superimposed text based on pollution readings

[1]:	http://aqicn.org/
[2]:	https://itunes.apple.com/gb/app/pollution-monitor/id1197195842?mt=12
[3]:	https://www.gnu.org/licenses/gpl-3.0.txt
[4]:	http://aqicn.org/api/
[5]:	http://aqicn.org/data-platform/token/