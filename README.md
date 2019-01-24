# Minecraft_TurtleApi
An object oriented abstraction of the turtle api in the Minecraftmod Computercraft. Programmed in lua

So far implemented:

- class for fuel management:

   - can choose slots for fuel
  
   - Refuel if needed
  
   - check if enought fuel is loaded in the turtle and in the turtle inventory to make a movement
  
- class for  turtle movement

   - can take a table of predefined movement to execute one after another
  
   - will check beforehand, if you have enough fuel to execute the movement

   - you can calculate the amount of movements(and thus fuel) needed for a given movement table
   - move in any direction a desired amount.

   - you can supply a custom function that will be executed between every step the turtle does

   - can be used to dig a tunnel for example
      
- class for farming with the turtle

   - give a table of movements to walk to the field
  
   - set the heigth and width of the field
  
   - determine the size of the farm by supplieng its dimension and the turtle will act accordingly
  
   - a post movement action, to move from the field after farming to another location

# Getting started
You can usually find the computercraft folder with the folders of your computers under 
**%appdata%/.minecraft/saves/[YourWorldnNameHere]/computers/[NumberOfAComputer]**
**I highly advise to use the setlabel command on your computers, to make them persisnte even after destroying them again**

>If you dont find your computer there, its probably because you did not create a file on the computer and saved it. Computercraft will only create a folder for a turtle/computer if you have at least one saved file on the computer.
 1. Clone the repo to a local folder
 
 2. Make the Api available inside of the virtual computers, in which you want to use it.
    - You can either copy the api folder from the local repo to the local computer folder
    
    - or you can copy the  **createhardLinks.py** script from the repo into your computerfolder, after changing the api path in the script, and execute it in your computer folder to create links to the api, that will thus update the api on  the computer if you make changes to it in your local repo.
