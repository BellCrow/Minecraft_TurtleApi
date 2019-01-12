# Minecraft_TurtleApi
An object oriented abstraction of the turtle api in the Minecraftmod Computercraft. Programmed in lua

So far implemented:

-class for fuel management:

  -can choose slots for fuel
  
  -Refuel if needed
  
  -check if enought fuel is loaded in the turtle and in the turtle inventory to make a movement
  
-class for  turtle movement

  -can take a table of predefined movement to execute one after another
  
    -will check beforehand, if you have enough fuel to execute the movement
    
    -you can calculate the amount of movements(and thus fuel) needed for a given movement table
    -move in any direction a desired amount.
    
    -you can supply a custom function that will be executed between every ste the turtle does
    
      -can be used to dig a tunnel for example
      
-class for farming with the turtle (in development!)

  -give a table of movements to walk to the field
  
  -set the heigth and width of the field
  
  -a post movement action, to move from the field after farming to another location
