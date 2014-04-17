define($DEV eth1, $DADDR 127.0.0.1, $GW $DEV:gw)

FromDevice($DEV)
	-> c :: Classifier(12/0800, 12/0806 20/0002, -)
	-> CheckIPHeader(14)
	-> ip :: IPClassifier(icmp echo, -)
	-> pingr :: ICMPPingResponder
