// newping.click

define($DEV eth3, $DADDR 127.0.0.1)

 FromDevice($DEV)
//ICMPPingSource(1.0.0.1,1.0.0.2)
	-> IPPrint(icmp-ok)
	-> Strip(14)
	-> IPPrint(icmp-ok)
	-> CheckIPHeader(14)
	-> Classifier(12/0800) // IP packets
	-> icmpr :: ICMPPingResponder;

icmpr[1]
	//-> ipp :: IPPrint(icmp-ok);

//ipp[0]	
//	-> [0] Print(icmp-ok)
	-> Print(icmp-ok)
	-> d :: Discard;
//	-> ToDevice($DEV);

icmpr[0]
	-> Print(icmp-ok)
	-> d;
