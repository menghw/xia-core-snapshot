define($COUNT 50000000);
define($PAYLOAD_SIZE 1300);
define($HEADROOM_SIZE 148);
define($OUTDEVICE eth3, $INDEVICE eth5, $DST_ETHER 00:1b:21:a3:d7:45);

// aliases for XIDs
XIAXIDInfo(
    HID0 HID:0000000000000000000000000000000000000000,
    HID1 HID:0000000000000000000000000000000000000001,
    AD0 AD:1000000000000000000000000000000000000000,
    AD1 AD:1000000000000000000000000000000000000001,
    RHID0 HID:0000000000000000000000000000000000000002,
    RHID1 HID:0000000000000000000000000000000000000003,
    CID0 CID:2000000000000000000000000000000000000001,
);


gen :: InfiniteSource(LENGTH $PAYLOAD_SIZE, ACTIVE false, HEADROOM $HEADROOM_SIZE)
//-> Script(TYPE PACKET, write gen.active false)       // stop source after exactly 1 packet
-> XIAEncap(
    DST RE  HID1,
    SRC RE  HID0)
-> XIAPrint("out")
-> EtherEncap(0x9999, 00:1a:92:9b:4a:77 , $DST_ETHER)
//-> Clone($COUNT)
-> RatedUnqueue(2)
-> Queue()
-> ToDevice($OUTDEVICE);

FromDevice($INDEVICE, PROMISC true) 
-> c0 :: Classifier(12/9999, -)
-> Strip(14) -> MarkXIAHeader()
-> XIAPrint("in") -> Discard;

c0[1]->ToHost;
Script(write gen.active true);
