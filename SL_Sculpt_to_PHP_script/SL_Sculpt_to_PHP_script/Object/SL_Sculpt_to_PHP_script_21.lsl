// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:04
// :ID:790
// :NUM:1099
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// vertex2sculpt.php
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

require_once('openloft_config.inc.php');
require_once('func.gdbundle.php');

if( defined(ENABLE_AUTH) && !$is_allowed) die('Not Allowed');

define('FLOAT_PRECISION',3);

//Make the directories if they are missing
if( !file_exists("cache") ) mkdir("cache");
if( !file_exists("sculpts") ) mkdir("sculpts");

function fullpath($file){
        $host  = $_SERVER['HTTP_HOST'];
        $uri  = rtrim($_SERVER['PHP_SELF'], "/\\");
        $uri = str_replace(basename($_SERVER['PHP_SELF']),"",$uri);
        return "http://$host$uri$file";
}


class vertex {
        var $x=0.0;
        var $y=0.0;
        var $z=0.0;
        function load(/*.array.*/ $arr) {
                $this->x = floatval($arr[0]);
                $this->y = floatval($arr[1]);
                $this->z = floatval($arr[2]);
        }
        function mult($scalar=1.0)
        {
                $this->x *=floatval($scalar);
                $this->y *=floatval($scalar);
                $this->z *=floatval($scalar);
        }
        function combine(/*.vertex.*/ $vector)
        {
                $this->x /= $vector->x;
                $this->y /= $vector->y;
                $this->z /= $vector->z;
        }
        function add(/*.vertex.*/ $vertex)
        {
                $this->x += $vertex->x;
                $this->y += $vertex->y;
                $this->z += $vertex->z;
        }
        function get_array() {
                return array($this->x,$this->y,$this->z);
        }
        function toString() {
                return "<$this->x,$this->y,$this->z>";
        }
};

function make_sculpty($verts,$sc,$o,$width,$height,$upsample, $smooth) {
        global $owner_key,$object_key;

        $image = imagecreatetruecolor($width,$height);

        

        $scale = new vertex;
        $orig = new vertex;

        $orig->load($o);
        $orig->mult(-1);

        $scale->load($sc);
        $scale->mult(0.5); //Radius

        $this_row = 0;
        
        foreach( $verts as $vert_row ) //Rows
        {
                $x = 0;
                $row = explode("|",$vert_row);
                $point = FALSE;
                if( count($row) == 1 ) $point = TRUE;
                $y = $height - 1 - $this_row;
                foreach( $row as $v ) //Columns
                {
                        $vert = new vertex;
                        $vert->load(explode(",",$v));
                        $vert->add($orig);
                        $vert->combine($scale);
        
                        $red = floor(127*round($vert->x,FLOAT_PRECISION))+128;
                        $green = floor(127*round($vert->y,FLOAT_PRECISION))+128;
                        $blue =  floor(127*round($vert->z,FLOAT_PRECISION))+128;

                        if( $red > 255) $red = 255;
                        if( $blue > 255) $blue = 255;
                        if( $green > 255) $green = 255;
                        if( $red < 0) $red = 0;
                        if( $blue < 0) $blue = 0;
                        if( $green < 0) $green = 0;                     

                        $color = imagecolorallocate($image,$red,$green,$blue);

                        if($point) {
                                imageline($image,0,$y,$width-1,$y,$color);
                                break;
                        } else {
                                imagesetpixel($image,$x,$y,$color);
                        }
                        ++$x;
                        if($x >= $width) break;
                }
                $this_row++;
                if( $this_row >= $height) break;
        }
        
        //Up-sample the image 
        if($upsample) 
        {
                $new_h = $height*2;
                $new_w = $width*2;
                $image_resampled = imagecreatetruecolor($new_w,$new_h);
                imagecopyresized($image_resampled , $image , 0 , 0 , 0 , 0 , $new_w , $new_h , $width, $height );
                imagedestroy($image);
                $image = $image_resampled;
        }

        if( $smooth == "gaussian" ) {
                $gaussian = array(array(1.0, 2.0, 1.0), array(2.0, 4.0, 2.0), array(1.0, 2.0, 1.0));
                imageconvolution($image, $gaussian, 16, 0);
        }
        if( $smooth == "linear" ) {
                $linear = array(array(1.0, 1.0, 1.0), array(1.0, 1.0, 1.0), array(1.0, 1.0, 1.0));
                imageconvolution($image, $linear, 9, 0);
        }

        //Name it after the object and owner key, otherwise the name given during the render command
        $imagename = "$owner_key-$object_key.png";
        if(isset($_REQUEST['name'])) $imagename = $_REQUEST['name'];

        imagepng($image,"sculpts/$imagename");
        imagedestroy($image);
        echo("\nYour Sculpt: <" . fullpath("sculpts/$imagename") . ">\n");
}

$action = $_REQUEST['action'];

//Make 'unique' filename
$image_id = $owner_key;

if($action == "upload")
{

        //Convinence Variables
        $issplit = FALSE;
        if(isset($_REQUEST['split']))
        {
                $issplit = TRUE;
                $s = explode("of",stripslashes($_REQUEST['split']));
                $start = $s[0];
                $end = $s[1];
        }

        $verts = stripslashes($_REQUEST['verts']);
        $row = stripslashes($_REQUEST['row']);
        $params = stripslashes($_REQUEST['params']);

        //Parse Verticies
        $nverts = preg_replace("/> *, *</","|",$verts);
        $nverts = preg_replace("/[> <]/","",$nverts);

        //Write vertex packet splits to a split file
        //Populate the verticies on the row when all splits are received
        if($issplit) {

                $fd = fopen("cache/$image_id.split","a+");
                $fd || die("Could not open file: " . "$image_id.split$row");
                fwrite($fd,$nverts);
                if($start == $end) {
                        $nverts = fread($fd, filesize("$image_id.split$row"));
                        fclose($fd);
                        $fd = FALSE;
                        unlink("cache/$image_id.split");
                } else {
                        $nverts = FALSE;
                }
                if($fd) fclose($fd);
        }
        
        $row_filename = "cache/$image_id-$row.verts";

        //Write vertex dump to file
        if( $nverts ) {
                $fd = fopen($row_filename,"w");
                $fd || die("Could not open file: $row_filename");
                fwrite($fd,"$nverts");
                fclose($fd);
        }
}

if( $action == "render") {
        $xverts = stripslashes($_REQUEST['w']);
        $yverts = stripslashes($_REQUEST['h']);
        $smooth = stripslashes($_REQUEST['smooth']);
        $scale = stripslashes($_REQUEST['scale']);
        $orig = stripslashes($_REQUEST['org']);
        $input = array();
        for($r = 0; $r < $yverts; ++$r)
        {
                $row_filename = "cache/$image_id-$r.verts";
                if( $input[] = file_get_contents($row_filename) ) {
                        //unlink($row_filename);
                } else {
                        die("Couldn't open file for row $r");
                }
        }
        //Parse Scale
        $scale = preg_replace("/[> <]/","",$scale);
        $scale = explode(",",$scale);

        //Parse Origin
        $orig = preg_replace("/[> <]/","",$orig);
        $orig = explode(",",$orig);

        make_sculpty($input,$scale,$orig,$xverts,$yverts,TRUE,$smooth);
}
?>
