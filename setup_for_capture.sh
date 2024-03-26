#! /usr/bin/env bash
#https://useyourloaf.com/blog/remote-packet-capture-for-ios-devices/
set -e

UDID=$1
PCAP_FILENAME=$2
echo ${UDID} ${PCAP_FILENAME}
rvictl -s ${UDID}
# tcpdump -i rvi0 -w ${PCAP_FILENAME} -X
# rvictl -x ${UDID}
