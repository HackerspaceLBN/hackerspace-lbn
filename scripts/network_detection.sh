echo "" > devices.txt
cat /proc/net/arp | tail | awk '{
  if (system("ping -c 1 " $1 " -w 2 >/dev/null"))
    # Ping failed, device not connected
    print "{\"mac\":\""$4"\",\"flag\":\"0x0\"}" >> "devices.txt"
  else
    # Ping succeded, device connected
    print "{\"mac\":\""$4"\",\"flag\":\"0x2\",\"ip\":\""$1"\"}" >> "devices.txt"
  end
}' 

# If ping is successful display device as present
cat /tmp/dhcp.leases | tail | awk '{
  if (system("ping -c 1 " $3 " -w 2 >/dev/null"))
    # Ping failed, device not connected
    print "{\"mac\":\""$2"\",\"flag\":\"0x0\"}" >> "devices.txt"
  else
    # Ping succeded, device connected
    print "{\"mac\":\""$2"\",\"flag\":\"0x2\",\"name\":\""$4"\",\"ip\":\""$3"\"}" >> "devices.txt"
}'

cat devices.txt

awk -vRS="" -vOFS=',' '$1=$1' devices.txt | sed 's/ /,/g' | awk '{
  print "{\"data\":["$0"]}"  > "devices.txt"
}'
