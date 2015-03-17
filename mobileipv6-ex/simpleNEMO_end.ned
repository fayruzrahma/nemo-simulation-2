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
import inet.networklayer.common.InterfaceTable;
import inet.nodes.ipv6.StandardHost6;
import inet.nodes.wireless.AccessPoint;
import inet.nodes.xmipv6.MobileRouter6;

module SimpleNeMO6_end
{
    parameters:
        @node;
        @labels(node,ethernet-node,wireless-node);
        string mobilityType = default("StationaryMobility");

    gates:
        inout ethg[];
        input radioIn @directIn;
    submodules:
        interfaceTable: InterfaceTable {
            @display("p=590,37");
        }
                wlan: <default("Ieee80211Nic")> like IWirelessNic {
                    parameters:
                        @display("p=396,216;q=queue");
                }
        notificationBoard: NotificationBoard {
            parameters:
                @display("p=497,37");
        }
        
        R: MobileRouter6 {
            parameters:
                @display("p=196,305");
                numRadios = 1;
        }
        configurator: FlatNetworkConfigurator6 {
            @display("p=407,37");
        }
        LFN6: StandardHost6 {
            @display("p=344,305");
        }

        mobility: <mobilityType> like IMobility {
            @display("p=336,45");
        }
    connections allowunconnected:
//        radioIn --> R.radioIn++;
                radioIn --> wlan.radioIn;
                wlan.upperLayerOut --> ethernetline --> R.ethg$i++;
                wlan.upperLayerIn <-- ethernetline <-- R.ethg$o++;
        R.ethg++ <--> ethernetline <--> LFN6.ethg++;
}
