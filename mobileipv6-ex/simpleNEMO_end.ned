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
import inet.linklayer.ieee80211.radio.Ieee80211Radio;
import inet.linklayer.radio.IRadio;
import inet.mobility.contract.IMobility;
import inet.networklayer.autorouting.ipv6.FlatNetworkConfigurator6;
import inet.networklayer.common.InterfaceTable;
import inet.nodes.ipv6.StandardHost6;
import inet.nodes.wireless.AccessPoint;
import inet.nodes.xmipv6.MobileRouter6;
import inet.world.radio.ChannelControl;


module SimpleNeMO6_end
{
    parameters:
        @node;
        @labels(node,ethernet-node,wireless-node);
        string mobilityType = default("StationaryMobility");
        string opMode @enum("b","g","a","p") = default("g");
        double bitrate @unit("bps") = default(opMode == "b" ? 11Mbps : opMode == "p" ? 27Mbps : 54Mbps);

    gates:
        inout ethg[];
        input radioIn @directIn;
    submodules:
       R: MobileRouter6 {
            parameters:
                @display("p=196,305");
//                numRadios = 1;
        }
        LFN6: StandardHost6 {
            @display("p=344,305");
        }

        mobility: <mobilityType> like IMobility {
            @display("p=336,45");
        }

        radio: Ieee80211Radio {
            parameters:
                phyOpMode = opMode;
                bitrate = bitrate;
                @display("p=103,305");
        }

    connections allowunconnected:
        //        radioIn --> R.radioIn++;
        //        radioIn --> wlan.radioIn;
        radioIn --> radio.radioIn;
        radio.upperLayerIn <-- ethernetline <-- R.ethg$o++;
        radio.upperLayerOut --> ethernetline --> R.ethg$i++;
        R.ethg++ <--> ethernetline <--> LFN6.ethg++;
}
