az vm list #This lists out all Virtual Machines under your Azuer Subscription

az vm list --resource-group MyResourceGroup #lists out particular resource group's vm

az vm create \  #this is to create vm
  --resource-group "learn-cd0eca5c-5603-444f-a10e-e3c4f6065eab" \
  --name my-vm \
  --public-ip-sku Standard \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys    

  az vm extension set \  #To create NGINX on VM // here NGINX is open source web server , ... EXTENSION is service provided by AZURE to POST-DEPLOYMENT configoration and Automation of task
  --resource-group "learn-cd0eca5c-5603-444f-a10e-e3c4f6065eab" \
  --vm-name my-vm \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --version 2.1 \
  --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
  --protected-settings '{"commandToExecute": "./configure-nginx.sh"}'  

#A22

az network nsg list \
  --resource-group "learn-7a7b8a2c-9c12-43b0-b9af-887d5acabdf3" \
  --query '[].name' \
  --output tsv   



# Code to store VM ip address 
  IPADDRESS="$(az vm list-ip-addresses \
  --resource-group "learn-920865e9-2b07-446e-8c1a-25ca072a2e8e" \
  --name my-vm \
  --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
  --output tsv)"  

  curl --connect-timeout 5 http://$IPADDRESS   #it sets time on how long curl will wait for response 
  # Curl is basically command line tool use to transfer data form or to a server ... typically HTTP HTTPS and FTP 
 
#this will not work .. lets check whats wrong 
##Lets try to find ip and browse it 
echo $IPADDRESS  
# this wont work eather 

# code to list out Network Security Group(NGS) list 
az network nsg list \
  --resource-group "learn-920865e9-2b07-446e-8c1a-25ca072a2e8e" \
  --query '[].name' \
  --output tsv     #my-vmNGS will be the output

  # code to check ngs rules list 
  az network nsg rule list \
  --resource-group "learn-920865e9-2b07-446e-8c1a-25ca072a2e8e" \
  --nsg-name my-vmNSG 

  # to checked in formatted version
  az network nsg rule list \
  --resource-group "learn-920865e9-2b07-446e-8c1a-25ca072a2e8e" \
  --nsg-name my-vmNSG \
  --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
  --output table    
##OUTPUT IS : 
Name              Priority    Port    Access
-----------------  ----------  ------  --------
default-allow-ssh  1000        22      Allow


#Create the NETWORK SECURITY RULE 

##Run the following az network nsg rule create command to create a rule called allow-http that allows inbound access on port 80:
## Reason being port 22 is for ssh only and we need to access form http ... for http prot is 80
# and we need to change priority to 100 because if multiple rule collaps then lower number in priority will run first ... so we need to put our new rules priority lower then ssh
# but changing the priroriy will not affect our program since these are in differnt port already

az network nsg rule create \
  --resource-group "learn-920865e9-2b07-446e-8c1a-25ca072a2e8e" \
  --nsg-name my-vmNSG \
  --name allow-http \
  --protocol tcp \
  --priority 100 \
  --destination-port-range 80 \
  --access Allow    

#Check ngs rules again

az network nsg rule list \
  --resource-group "learn-920865e9-2b07-446e-8c1a-25ca072a2e8e" \
  --nsg-name my-vmNSG \
  --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
  --output table    

#now print the ipaddresses data

curl --connect-timeout 5 http://$IPADDRESS

## here you will see whatever you have seted up in that ip address. IN our case ;:
<html><body><h2>Welcome to Azure! My name is my-vm.</h2></body></html>

## if you go to that ip address then you will see webstie saying 
Welcome to Azure! My name is my-vm.
