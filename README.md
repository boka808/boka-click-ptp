boka-click-ptp
==============

* Configuration and element files


Network config
--------------

* When using the configurations on an internal network, it is important
  to have the correct network configurations.

* Set up the gateway address of the internal network.

  1. Find the interface name by using ifconfig.

  2. Edit the /etc/network/interfaces file and set the interface to
     static.  For Ubuntu Virtual Box, it should look something like this:

```
     auto eth0
     iface eth0 inet static
     address 10.13.14.101
     netmask 255.255.255.0
     gateway 10.13.14.102
```

Files
-----

* conf/icmp/pingrecv.click

  * The new implementation of an ICMP ping responder

  * Uses ARPQuerier to check for the original device's IP address.
    This replaces the Ethermirror in a previous build.
    Rather than switching the source and destination addresses in the
    packet, the ARPQuerier sets the return address for the packet
    created by ICMPPingResponder.

  * To run the command properly:
    click-install pingrecv.click DEV=[eth#] GW=[ipaddr.of.gw.device]

  * To run the corresponding test-ping.click command:
    click-install test-ping.click DEV=[eth#] DADDR=[dest_ip] GW=[gw_ip]

* conf/reference/newping.click (DEPRECATED)

* ref/linkhelp.txt

  * A description of how to use the hard link command

  * Useful for hosting files in git and using them in click

* ref/search.h4x

  * A script to help search for usage of classes in click/conf

  * To use, run search.h4x; prompts will ask for location and string
    to match.
