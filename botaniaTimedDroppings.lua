local botaniaInterface = peripheral.wrap("tileinterface_8")

coalFP = {id= "minecraft:coal", dmg = 0}

while true do
  botaniaInterface.exportItem(coalFP, "north", 8, 1)
  print("exported items")
  sleep(41)
end
