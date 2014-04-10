// test-ptp.click

// Used to push fake ptp data

define($DEV eth0, $DADDR 127.0.0.1, $GW $DEV:gw)

FromDevice($DEV)
	// Create a classifier
	-> c :: Classifier(12/0800, 12/0806 20/0002, -)
	// Check the IP Header
	-> CheckIPHeader(14)
	-> ip :: IPClassifier(icmp echo-reply, -)
	-> ping :: ICMPPingSource($DEV, $DADDR,INTERVAL 1)
	-> SetIPAddress($GW)
	-> arpq :: ARPQuerier($DEV)
	-> IPPrint
	-> q :: Queue
	-> { input -> t :: PullTee -> output; t [1] -> ToHostSniffers($DEV) }
	-> ToDevice($DEV);
arpq[1]	-> q;
c[1]	-> t :: Tee
	-> [1] arpq;
t[1]	-> host :: ToHost;
c[2]	-> host;
ip[1]	-> host;
