// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:04
// :ID:790
// :NUM:1098
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// openloft_config.inc.php
// :CODE:
<?
//      This file is part of OpenLoft.
//
//      OpenLoft is free software: you can redistribute it and/or modify
//      it under the terms of the GNU General Public License as published by
//      the Free Software Foundation, either version 3 of the License, or
//      (at your option) any later version.
//
//      OpenLoft is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//      GNU General Public License for more details.
//
//      You should have received a copy of the GNU General Public License
//      along with OpenLoft.  If not, see <http://www.gnu.org/licenses/>.
//
//      Authors: Falados Kapuskas, JoeTheCatboy Freelunch

require_once 'http_request.inc.php';
//--Configuration Parameters--//

//--Uncomment the below line to enable authentication
//  To only allow the following users with the correct password
//  This is disabled by default  
//define('ENABLE_AUTH','1');

//--Avatars allowed to access the OpenLoft server
$ll_allowed = array(
        "fdbec268-0518-49f7-a334-320d70375c75", //Falados Kapuskas
        "22c701fd-d887-40d9-ae92-7cfe8a641335" //JoeTheCatboy Freelunch
);
//--The password to use for the open-loft server
$ll_password = 'openloft';

//--Subnets for LL Servers--//
$ll_subnets = array(
        "8.2.32.0/22",
        "63.210.156.0/22",
        "64.129.40.0/22",
        "64.129.44.0/22",
        "64.154.220.0/22",
        "8.4.128.0/22",
        "8.10.144.0/21",
        "216.82.0.0/18"
);

//--Other Neat Stuff--//

function net_match($network, $ip) {
          // determines if a network in the form of 192.168.17.1/16 or
          // 127.0.0.1/255.255.255.255 or 10.0.0.1 matches a given ip
          $ip_arr = explode('/', $network);
          $network_long = ip2long($ip_arr[0]);

          $x = ip2long($ip_arr[1]);
          $mask =  long2ip($x) == $ip_arr[1] ? $x : 0xffffffff << (32 - $ip_arr[1]);
          $ip_long = ip2long($ip);

          // echo ">".$ip_arr[1]."> ".decbin($mask)."\n";
          return ($ip_long & $mask) == ($network_long & $mask);
}

$is_ll = FALSE;
foreach( $ll_subnets as $network) {
        if(net_match($network,$_SERVER['REMOTE_ADDR'] )) {
                $is_ll = TRUE;
                break;
        }
}

$p = $_REQUEST['p'];
$request = new http_request();

$nheaders = array_map('strtolower',$request->headers());
$headers = array();
foreach( $nheaders as $key => $value )
{
        $headers[strtolower($key)] = $value;
}

//OWNER
$owner_key = $headers['x-secondlife-owner-key'];

//OBJECT
$object_key = $headers['x-secondlife-object-key'];

$is_allowed = $is_ll && 
        in_array(trim(strtolower($owner_key)),$ll_allowed) &&
        $p == $ll_password;
?>
