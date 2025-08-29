--Allowed Computer IDs (Add an entra "or" for more, must have 2 IDs)
function IDv(x)
 if x == 11 or x == 25 then
  idcheck = true
   if not currentClient then
    currentClient = id
    print("Locked to ID:", currentClient)
   end                           --Computer Sides
   rednet.send(id,"IDTrue","31") --Top    =Door Closed Signal
  else                           --Front  =Ender Modem
  idcheck = false                --Left   -Open Door Signal
  end                            --Right  -Close Door Signal
 end                             --Back   =NONE
                                 --Bottom =Speaker
--Open modem
rednet.open("front")
local currentClient = nil

--Client Lock
while true do
 id,message = rednet.receive("30")
 --Ignore others if busy
 if currentClient and id ~= currentClient then
  rednet.send(id, "BUSY")
 end


 --Reset Outputs
 redstone.setOutput("left",false)
 redstone.setOutput("right",false)

 --Door status logging
 --Door Closed
 if redstone.getInput("top") then
  print("Door Started Sealed")
 end
 --Door Open
 if not redstone.getInput("top") then
  print("Door Started Unsealed")
 end

 --Get allowed key
 IDv(id)
 sleep(1)
 if message == "V4u17" then --key here
  request = true
  rednet.send(id,"KeyTrue","32")
  else
  request = false
  rednet.send(id)
 end
 sleep(1)

 --Is message and ID allowed
 if request == true and idcheck == true then
  allowed = true
  print(id,"Authorised")
  rednet.send(id,"AccTrue","33")
  else
  allowed = false
  print(id,"Unauthorised")
 end
 sleep(1)
 
 --Open Door
 if allowed == true and redstone.getInput("top") then
  print("Unsealing Door")
  shell.run("speaker play door.dfpwm")
  rednet.send(id,"The Vault Door is now opening.","34")
  redstone.setOutput("left",true)
  sleep(1)
  redstone.setOutput("left",false)
  shell.run("speaker play screech.dfpwm")
  sleep(18)
   if not redstone.getInput("top") then
   rednet.send(id,"Door opened.","35")
   else
   rednet.send(id,"ERROR: UNABLE TO UNSEAL","35")
  end
  shell.run("startup")
 end

 --Close Door
 if allowed == true and not redstone.getInput("top") then
  print("Sealing Door")
  rednet.send(id,"The Vault Door is now closing.","34")
  redstone.setOutput("right",true)
  sleep(1)
  redstone.setOutput("right",false)
  sleep(39)
   if not redstone.getInput("back") then
   rednet.send(id,"Door closed.","35")
   else
   rednet.send(id,"ERROR: UNABLE TO SEAL","35")
  end
  shell.run("startup.lua")
 end
end
