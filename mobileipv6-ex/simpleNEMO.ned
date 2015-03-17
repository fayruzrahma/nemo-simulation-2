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
import inet.linklayer.ethernet.EtherHub;
import inet.linklayer.IWirelessNic;
import inet.mobility.contract.IMobility;
import inet.networklayer.autorouting.ipv6.FlatNetworkConfigurator6;
import inet.nodes.wireless.AccessPoint;
import inet.nodes.ipv6.Router6;

module SimpleNeMO6
{
    parameters:
        @node;
        @labels(node,ethernet-node,wireless-node);
        int numOfLFNs;
        int numOfLMNs;
        string mobilityType;
    gates:
        inout ethg[];
        input radioIn @directIn;
    submodules:
        notificationBoard: NotificationBoard {
            parameters:
                @display("p=484,16");
        }
//        wlan: <default("Ieee80211Nic")> like IWirelessNic {
//            parameters:
//                @display("p=396,216;q=queue");
//        }
        mobility: <mobilityType> like IMobility {
            parameters:
                @display("p=36,509");
        }
        R: Router6 {
            parameters:
                @display("p=196,305");
        }
        AP_Root: AccessPoint {
            parameters:
                @display("p=248,410;i=device/accesspoint_s");
				//mobilityType = "BasicMobility";
        }
        configurator: FlatNetworkConfigurator6 {
            @display("p=435,501");
        }
    connections allowunconnected:
        radioIn --> R.ethg$i++;
//        wlan.upperLayerOut --> R.ethg$i++;
//        wlan.upperLayerIn <-- R.ethg$o++;
        AP_Root.ethg$i++ <-- ethernetline <-- R.ethg$o++;
        AP_Root.ethg$o++ --> ethernetline --> R.ethg$i++;
}
