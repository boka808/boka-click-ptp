// test-tap.click

// This user-level configuration tests the KernelTap element, which accesses
// Linux's ethertap device (or, equivalently, *BSD's /dev/tun* devices). These
// devices let user-level programs trade packets with the kernel.  You will
// need to run it as root.
//
// This configuration should work on FreeBSD, OpenBSD, and Linux. It should
// produce a stream of 'tap-ok' printouts if all goes well. 
// On OpenBSD, you may need to run
//   route add 1.0.0.0 -interface 1.0.0.1
// after starting the Click configuration.
//
// See test-tun.click for the KernelTun version of this configuration, which
// is better documented.

// Linux kernel taps don't work unless you set Ethernet addresses right.
AddressInfo(tap_local 1:1:1:1:1:1, tap_remote 2:2:2:2:2:2);

// The ETHER argument is required on Linux, but ignored on FreeBSD.
// Define the tap element
tap :: KernelTap(1.0.0.1/8, ETHER tap_remote);

// Output the an ICMPPing source to the tap
ICMPPingSource(1.0.0.2, 1.0.0.1)
	-> out :: EtherEncap(0x0800, tap_local, tap_remote)
	-> tap;

// Output the tap to a classifier
tap	// -> Print(tap-in)
	-> c :: Classifier(12/0800, 12/0806);

// Take in from the classifier c[0]
// strip off 14 bytes
// check the ip header
// output to the output to the ipclassifier (ipc)
c[0]	-> Strip(14)
	-> ch :: CheckIPHeader
	-> ipc :: IPClassifier(icmp echo-reply, icmp echo, -)
	-> IPPrint(tap-ok)
	-> d :: Discard;

// take input from ipclassifier ipc[1] and respond with
// ICMPPingResponder to the out etherencap
ipc[1]	-> Print(tap-ping)
	-> ICMPPingResponder
	-> out;

// output to Discard from ipc[2]
ipc[2]	-> d;

// Debug bad headers
// discard
ch[1]	-> Print(tap-bad)
	-> d;

// Output the classifier c[1] to ARPResponder
// output to tap
c[1]	-> ARPResponder(0/0 tap_local)
	-> tap;
