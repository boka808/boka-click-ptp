// test-ping.click

// This kernel configuration tests the FromDevice and ToDevice
// elements by sending pings to host xxx.xxx.xxx.xxx
// via 'eth0'. Change the 'define' statement to use another device or
// address or gateway address, or run e.g. `click-install
// test-ping.click DEV=eth1` to change a parameter at the command
// line.
//
// You should see, in `dmesg` or /var/log/messages, a sequence of
// "icmp echo" printouts intermixed with "ping :: ICMPPingSource"
// receive reports. If you don't, make sure that your device and
// gateway address are correct. (The address in
// `/click/SetIPAddress*/addr` should equal the default gateway for
// the relevant device.) Also check out the contents of
// /click/ping/summary.

define($DEV eth1, $DADDR 127.0.0.1, $GW $DEV:gw)

// Listen to eth1 and respond on it
FromDevice($DEV)
	-> ICMPPingResponder($DEV)
	-> ToDevice($DEV);

//	-> c :: Classifier(12/0800, 12/0806);
	// Changed this line to icmp echo instead of echo-reply

//c[0]	-> Strip(14)
//	-> CheckIPHeader
//	-> ip :: IPClassifier(icmp echo, -)
//	-> IPPrint(ping-ok)
//	-> Discard;

//ip[0]	-> Print(rap-ping)
//ip[0]	-> ICMPPingResponder
//	-> ToDevice($DEV);
	//-> SetIPAddress($GW)
	//-> arpq :: ARPQuerier($DEV)
	//-> q :: Queue
	//-> { input -> t :: PullTee -> output; t [1] -> ToHostSniffers($DEV) }


//arpq[1]	-> q;
//c[1]	-> t :: Tee;
//	-> [1] arpq;
//t[1]	-> host :: ToHost;
//c[2]	-> host;
//ip[1]	-> host;
