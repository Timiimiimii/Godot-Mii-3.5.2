# GodotMii3.5.2
 Mii Heads recreated in Godot 3.5.2 for use in games.
# DISCLAIMER
There are very minor amounts of WEBFISHING code inside, as these scenes were originally from a mod in WEBFISHING. I am working to remove all WEBFISHING related assets. Additionally, please use mii_head_plus.tscn. It is the most accurate I have gotten so far.
# Loading Miis
In the Godot 3.5.2 version, only .CHARINFO loading is supported. Mii Names also are not supported as of now. To load a Mii, use the function MiiFileLoad() on the Mii Head with the file path to the Mii.
# Making the face move
To make custom face animations, toggle MiiFaceAnimation, which will activate MiiFaceAnimate(). the Mii will then follow the bone offsets of the MiiAnimBone skeleton.
