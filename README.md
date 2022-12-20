Simple example flutter app.

No idea if this works on iOS. I imagine it probably doesn't. Likely needs to ask for bluetooth permissions on iOS somehow, no idea how that gets done as I do not have an iOS device to test it on. Works on android though, and is capable of sending messages to bluetooth devices
that are capable of receiving them. 

The bluetooth page was mostly repurposed code from an example I found online. Seems to work pretty well, should be easily modifiable to give rovr its configs through bluetooth.

To run on iOS, no idea, probably similar to android?
To run on android, set up wireless debugging (or usb debugging), and do 'flutter run' in the console. It will automatically build and put the app
on your android device.
