require(library xia_router_template.click);
require(library xia_address.click);
require(library xia_vm_common.click);

router :: RouteEngine(RE AD1 HID1);

from_eth0 :: FromDevice(eth0, PROMISC true);
to_eth0 :: Queue() -> ToDevice(eth0);

from_tap0 :: FromDevice(tap0, PROMISC true);
to_tap0 :: Queue() -> ToDevice(tap0);

from_eth0
-> c0 :: Classifier(12/9999) -> Strip(14) -> MarkXIAHeader() -> [0]router;

from_tap0
-> c1 :: Classifier(12/9999) -> Strip(14) -> MarkXIAHeader() -> [0]router;

Idle -> [1]router;

router[0]
-> sw :: PaintSwitch;

sw[0]
//-> XIAPrint("xia_vm_hostA_relay:to_client")
-> EtherEncap(0x9999, RHID0, CLIENT) -> to_eth0;

sw[1]
//-> XIAPrint("xia_vm_hostA_relay:to_guest")
-> EtherEncap(0x9999, RHID0, GUEST) -> to_tap0;

sw[2]
//-> XIAPrint("xia_vm_hostA_relay:to_rhid1")
-> EtherEncap(0x9999, RHID0, RHID1) -> to_eth0;

router[1]
-> XIAPrint("xia_vm_hostA_relay:no_cache")
-> [0]router;

router[2]
-> XIAPrint("xia_vm_hostA_relay:no_cache")
-> Discard;

Script(write router/proc/rt_AD/rt.add AD0 4);
Script(write router/proc/rt_AD/rt.add AD1 4);
Script(write router/proc/rt_HID/rt.add RHID0 4);
Script(write router/proc/rt_HID/rt.add RHID1 2);
Script(write router/proc/rt_HID/rt.add HID0 1);
Script(write router/proc/rt_HID/rt.add HID1 0);

