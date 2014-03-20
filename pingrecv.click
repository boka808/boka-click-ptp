// pingrcv.click

// Choose which device to listen on
// through command line option DEV
// Ex: click-install pingrcv.click DEV=eth1

// Note: this overrides the default
// Linux ICMP responder for that device only

// Notes on ping packet BYTES
// First 6 are dest addr
// Second 6 are src addr
// Next 2 is type

define($DEV eth0, $GW $DEV:gw)

FromDevice($DEV)
	-> Print(recv-ok)
	// Forward only packets matching 0x0800
	// IP packets 0800
	// ARP packets 0806
	-> c :: Classifier(12/0800,12/0806 20/0002,12/0806 20/0001, -);

// Handle all packets with type 0x0800
c[0]
//	-> Print(IP-ok)
//	-> Print(BEFORE-STRIPPING-HEADER)
	-> Strip(14)
//	-> Print(AFTER-STRIPPING-HEADER)
//	-> Print(strip-ok)
	-> CheckIPHeader
	-> Print(checkip-ok)
	-> ipc :: IPClassifier(icmp echo-reply, icmp echo)
//	-> IPPrint(ipc-ok)
//	-> d :: Discard;

// Respond to packets of ICMP type
ipc[1]
	-> Print(ping-responding)
	-> icmpr :: ICMPPingResponder
	-> IPPrint(icmpr-ok)
	// Re-add the header stripped
//*	-> Unstrip(14)
	// Switch src macaddr with dst macaddr
//*	-> EtherMirror
	-> SetIPAddress($GW)
	-> arpq :: ARPQuerier($DEV)
	-> IPPrint
	// Make sure the frame matches ether
	-> EnsureEther
	-> Print(ETHER-ENCAP)
	-> q :: Queue
	-> { input -> t :: PullTee -> output; t[1] -> ToHostSniffers($DEV) }
	-> Print(GOING)
	-> ToDevice($DEV);
arpq[1] -> q;

// Handle all packets with type 0x0806
c[1]	-> t :: Tee
	-> [1] arpq;
t[1]	-> host :: ToHost;
c[2]	-> arpr :: ARPResponder($DEV)
	-> Print(ARPResponse)
	-> q;
arpr[1] -> host;
c[3]	-> Print(PASS-TO-HOST)
	-> host;
ipc[0]	-> host;

// Log non-icmp response packets
icmpr[1]
	-> Print(icmp1-NONICMP)
	-> host;
