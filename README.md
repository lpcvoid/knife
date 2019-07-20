# Knife
An open source, lightweight and no bullshit customization software for your Razer Blade.

![Screenshot of Knife](https://i.imgur.com/qdmHs4P.png)

Currently only works on Razer Blade 2018 Advanced. Support for other blade models is trivial though, and will come around soon.

# Why?
I love my Blade, but I hate Synapse. Bloated, needs Internet access, and looks like something a 13 year old would design, in my opinion. Knife aims to be something that your grandpa would design - small, gets the job done and out of your face afterwards.

Knife uses 4.4MB RAM when running, and no visible levels of CPU.

# How?
First, we need to change the USB driver to WinUSB, since that's easy to work with. I recommend using Zadig (https://zadig.akeo.ie/).

Change the driver of the Razer Device (Interface 2 on my Blade 2018 Advanced) to WinUSB, by clicking "Install Driver". You may need to enable "List all devices" in the Zadig options first. It should look like this afterwards (note that I already changed to WinUSB for this screenshot):

![Screenshot of zadig](https://i.imgur.com/vLgFjgh.png)

Then simply download the source and compile yourself, or grab a precompiled release. The zip contains two files (and exe and a dll), unpack both into the same directory. Run the exe. Done. Does not need any administrator privileges.

# Credits
This project stands on the shoulder of giants. I want to thank Openrazer for the initial idea, and a chap named @rsandoz for a lot of the headway into making Openrazer work on windows. I just hacked together both of their approaches into an easy to use DLL and GUI which runs on windows.

Have fun!
