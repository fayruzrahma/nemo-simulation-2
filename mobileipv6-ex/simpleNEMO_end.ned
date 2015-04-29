//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package mobileipv6_ex;

import inet.base.NotificationBoard;
import inet.linklayer.IMACAddressTable;
import inet.linklayer.IMACRelayUnit;
import inet.linklayer.ethernet.EtherHub;
import inet.linklayer.IWirelessNic;
import inet.linklayer.ethernet.EthernetInterface;
import inet.linklayer.ieee80211.radio.Ieee80211Radio;
import inet.linklayer.radio.IRadio;
import inet.mobility.contract.IMobility;
import inet.networklayer.autorouting.ipv6.FlatNetworkConfigurator6;
import inet.networklayer.common.InterfaceTable;
import inet.nodes.ipv6.StandardHost6;
import inet.nodes.wireless.AccessPoint;
import inet.nodes.wireless.RelayNemo;
import inet.nodes.xmipv6.MobileRouter6;
import inet.world.radio.ChannelControl;


module SimpleNeMO6_end
{
    parameters:
        @node;
        @labels(node,ethernet-node,wireless-node);
        string mobilityType = default("StationaryMobility");
        //wlanSta.mgmtType = "Ieee80211MgmtSTA";
        //"Ieee80211MgmtAP"

    gates:
        inout ethg[];
        input radioIn @directIn;
    submodules:
        interfaceTable: InterfaceTable {
            @display("p=266,167");
        }
        notificationBoard: NotificationBoard {
            @display("p=235,45");
        }
        R: MobileRouter6 {
            parameters:
                @display("p=196,305");
        }
        LFN6: StandardHost6 {
            @display("p=344,305");
        }

        mobility: <mobilityType> like IMobility {
            @display("p=336,45");
        }

        wlanSta: <"Ieee80211Nic"> like IWirelessNic {
            @display("p=95,305");
        }

//        relayNemo: RelayNemo {
//            @display("p=157,224");
//        }

        ethernetInterface: EthernetInterface {
            @display("p=156,235");
        }
    connections allowunconnected:
        radioIn --> wlanSta.radioIn;
        //        wlanSta.upperLayerOut --> ethernetline --> R.pintu$i;
        //        wlanSta.upperLayerIn <-- ethernetline <-- R.pintu$o;
        R.ethg++ <--> ethernetline <--> LFN6.ethg++;
        wlanSta.upperLayerOut --> ethernetInterface.upperLayerIn;
        ethernetInterface.upperLayerOut --> wlanSta.upperLayerIn;
        ethernetInterface.phys <--> ethernetline <--> R.ethg++;
}
