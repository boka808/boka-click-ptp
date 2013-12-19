// newping.click

// Notes on ping packet BYTES
// First 6 are dest addr
// Second 6 are src addr
// Next 2 is type

define($DEV eth0)

//d :: Discard;

 FromDevice($DEV)
//ICMPPingSource(1.0.0.1,1.0.0.2)
	-> Print(recv-ok)
	// Forward only packets matching 0x0800
	// IP packets 0800
	// ARP packets 0806
	-> c :: Classifier(12/0800,12/0806);
//	-> IPPrint(classifier-ok)
//	-> Classifier(12/0800) // IP packets
//	-> d;

c[1]	//-> d :: Discard;
	-> t :: Tee
	-> d :: Discard;
t[1]	-> host :: ToHost;
//	-> Print(ARP-ok)
//	-> Print(BEFORE-STRIPPING-HEADER)
//	-> Strip(14)
//	-> Print(AFTER-STRIPPING-HEADER)
//	-> CheckIPHeader(VERBOSE true)
//	-> Print(strip-ok)
//	-> ipc :: IPClassifier(icmp echo-reply, icmp echo)
//	-> IPPrint(ipc-ok)
//	-> d;

c[0]
	-> Print(IP-ok)
	-> Print(BEFORE-STRIPPING-HEADER)
	-> Strip(14)
	-> Print(AFTER-STRIPPING-HEADER)
	-> Print(strip-ok)
	-> CheckIPHeader
	-> Print(checkip-ok)
	-> ipc :: IPClassifier(icmp echo-reply, icmp echo)
	-> IPPrint(ipc-ok)
	-> d;

ipc[1]
	-> Print(ping-responding)
	-> icmpr :: ICMPPingResponder
	-> IPPrint(icmpr-ok)
	-> EtherEncap(0x0800,$DEV,$DEV)
	-> Print(ETHER-ENCAP)
//	-> d;
	-> q :: Queue
	-> { input -> t :: PullTee -> output; t[1] -> ToHostSniffers($DEV) }
	-> ToDevice($DEV);

icmpr[1]
	//-> ipp :: IPPrint(icmp-ok);

//ipp[0]	
//	-> [0] Print(icmp-ok)
//	-> out :: EtherEncap(0x0800,$DEV,$DEV)
	//-> Classifier(12/0800) // IP packets
	-> Print(icmp1-ok)
	-> d;
//	-> ToDevice($DEV);

//icmpr[0]
//	-> Print(icmp-ok)
//	-> d;
