// newping.click

define($DEV eth1)

// FromDevice($DEV)
ICMPPingSource(1.0.0.1,1.0.0.2)
	-> CheckIPHeader
	-> Classifier(12/0800) // IP packets
	-> ICMPPingResponder
	-> IPPrint(icmp-ok)
	-> Print(icmp-ok)
	-> Discard;
//	-> ToDevice($DEV);
