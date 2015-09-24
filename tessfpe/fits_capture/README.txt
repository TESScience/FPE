1. Power off the Observatory Sim; wait around 10 seconds for all front LEDs to turn off.
2. Configure host network interface to 192.168.100.x where x > 2
3. Compile and install UDP-enabled GSE onto the Observatory Sim
4. Connect dedicated Ethernet cable between Observatory Sim and Host
5. In one window, run command console via netcat:
   nc -v 192.168.100.1 5555
   (if this doesn't work, try -u)
6. In another window, run a listener:
   nc -l -u 7777


Notes:
------
#define	SERVER_CMDS_PORT	5555
#define	SERVER_DATA_PORT	6666
#define	CLIENT_DATA_PORT	7777
#define	RESP_BYTES		64
#define	DATA_BYTES		128
