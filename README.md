boka-click-ptp
==============

* Configuration and element files

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

* linkhelp.txt

  * A description of how to use the hard link command

  * Useful for hosting files in git and using them in click

* search.h4x

  * A script to help search for usage of classes in click/conf

  * To use, run search.h4x; prompts will ask for location and string
    to match.
