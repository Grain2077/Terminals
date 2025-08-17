--Clear screen
term.clear()
term.setCursorPos(1,1)
rednet.open("back")

--Print computer ID & send keys
--(Set Door key)
print("Validating User")
print("Identification...")
rednet.broadcast("V4u17","30")--HERE
id,message1 = rednet.receive("31",1)
if message1 == "IDTrue" then
print("... [",os.getComputerID(),"] done.")
elseif message1 == nil then
print("...")
print("...")
print("...")
print("[",os.getComputerID(),"] Request timed out.")
end
print("")
sleep(1)

--Auth key attempt
print("Authenticating Remote")
id,message2 = rednet.receive("32",1)
if message2 == "KeyTrue" then
print("Access Keys... done.")
elseif message2 == nil then
print("Access Keys... ERROR.")
end
print("")
sleep(1)

--Change Door position
print("Accessing Vault Door")
id,message3 = rednet.receive("33",1)
if message3 == "AccTrue" then
print("Control Interlink... done.")
print("")
sleep(1)
id,message4 = rednet.receive("34")
print(message4)
print("")
id,message5 = rednet.receive("35")
print(message5)
elseif message3 == nil then
print("Control Interlink... ERROR")
print("")

--Door ERROR
print("Vault Door unresponsive. ")
print("Please stand by")
print("and await Vault Security ")
print("for further instructions.")
os.sleep(2)
end
os.sleep(1)
os.run({}, "pip-boy/data.lua")
