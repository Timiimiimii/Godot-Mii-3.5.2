# GodotMii3.5.2
 Mii Heads recreated in Godot 3.5.2 for use in games.
 If you use this, please give credit.
 Example Images below.
![Screenshot 2024-12-16 030756](https://github.com/user-attachments/assets/546e2168-b868-4453-903f-c2a9e431b27b)

 ![Screenshot 2024-12-16 235322](https://github.com/user-attachments/assets/797d19cd-8d52-4129-b64b-62911430588c)

# DISCLAIMER
There are very minor amounts of WEBFISHING code inside, as these scenes were originally from a mod in WEBFISHING. I am working to remove all WEBFISHING related assets. Additionally, please use mii_head_plus.tscn. It is the most accurate I have gotten so far.

PLEASE GIVE CREDIT IF THIS PROJECT IS USED AND/OR EDITED!! The code that brings together the Mii head is ORIGINAL and NOT by Nintendo.
# Loading Miis
In the Godot 3.5.2 version, only .CHARINFO loading is supported. Mii Names also are not supported as of now. To load a Mii, use the function MiiFileLoad() on the Mii Head with the file path to the Mii.
# Making the face move
To make custom face animations, toggle MiiFaceAnimation, which will activate MiiFaceAnimate(). the Mii will then follow the bone offsets of the MiiAnimBone skeleton.
