// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:04
// :ID:790
// :NUM:1096
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// func.gdbundle.php
// :CODE:
<?php

/* 
 * Code taken from Imarty <http://code.google.com/p/imarty/ 
 * Original Licence: GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
 * New License: GPL v3 <http://www.gnu.org/licenses/gpl-3.0.html>
 */

//Here, it contains imageconvolution and imagefilter workaround
//these two functions only show up on PHP 5 and must be using bundled GD
//Well, even Imarty are not made for PHP4, not all servers uses bundled GD
//Like Ubuntu does come with PHP and GD, but there are not bundled.

if(!function_exists('imageconvolution')){
function imageconvolution($src, $filter, $filter_div, $offset){
        if ($src==NULL) {
                return false;
        }

        $sx = imagesx($src);
        $sy = imagesy($src);
        $srcback = ImageCreateTrueColor ($sx, $sy);
        ImageCopy($srcback, $src,0,0,0,0,$sx,$sy);

        if($srcback==NULL){
                return 0;
        }

        for ($y=0; $y<$sy; ++$y){
                for($x=0; $x<$sx; ++$x){
                        $new_r = $new_g = $new_b = 0;
                        $alpha = imagecolorat($srcback, $pxl[0], $pxl[1]);
                        $new_a = $alpha >> 24;

                        for ($j=0; $j<3; ++$j) {
                                $yv = min(max($y - 1 + $j, 0), $sy - 1);
                                for ($i=0; $i<3; ++$i) {
                                        $pxl = array(min(max($x - 1 + $i, 0), $sx - 1), $yv);
                                    $rgb = imagecolorat($srcback, $pxl[0], $pxl[1]);
                                        $new_r += (($rgb >> 16) & 0xFF) * $filter[$j][$i];
                                        $new_g += (($rgb >> 8) & 0xFF) * $filter[$j][$i];
                                        $new_b += ($rgb & 0xFF) * $filter[$j][$i];
                                }
                        }

                        $new_r = ($new_r/$filter_div)+$offset;
                        $new_g = ($new_g/$filter_div)+$offset;
                        $new_b = ($new_b/$filter_div)+$offset;

                        $new_r = ($new_r > 255)? 255 : (($new_r < 0)? 0:$new_r);
                        $new_g = ($new_g > 255)? 255 : (($new_g < 0)? 0:$new_g);
                        $new_b = ($new_b > 255)? 255 : (($new_b < 0)? 0:$new_b);

                        $new_pxl = ImageColorAllocateAlpha($src, (int)$new_r, (int)$new_g, (int)$new_b, $new_a);
                        if ($new_pxl == -1) {
                                $new_pxl = ImageColorClosestAlpha($src, (int)$new_r, (int)$new_g, (int)$new_b, $new_a);
                        }
                        if (($y >= 0) && ($y < $sy)) {
                                imagesetpixel($src, $x, $y, $new_pxl);
                        }
                }
        }
        imagedestroy($srcback);
        return true;
}
}

if(!function_exists('imagefilter')){
        function imagefilter($source, $var, $arg1 = null, $arg2 = null, $arg3 = null){
                #define('IMAGE_FILTER_NEGATE',0);
                #define('IMAGE_FILTER_GRAYSCALE',0);
                #define('IMAGE_FILTER_BRIGHTNESS',2);
                #define('IMAGE_FILTER_CONTRAST',3);
                #define('IMAGE_FILTER_COLORIZE',4);
                #define('IMAGE_FILTER_EDGEDETECT',5);
                #define('IMAGE_FILTER_EMBOSS',6);
                #define('IMAGE_FILTER_GAUSSIAN_BLUR',7);
                #define('IMAGE_FILTER_SELECTIVE_BLUR',8);
                #define('IMAGE_FILTER_MEAN_REMOVAL',9);
                #define('IMAGE_FILTER_SMOOTH',10);
                $max_y = imagesy($source);
                $max_x = imagesx($source);
           switch ($var){
               case 0:
                   $y = 0;
                   while($y<$max_y) {
                       $x = 0;
                       while($x<$max_x){
                           $rgb = imagecolorat($source,$x,$y);
                           $r = 255 - (($rgb >> 16) & 0xFF);
                           $g = 255 - (($rgb >> 8) & 0xFF);
                           $b = 255 - ($rgb & 0xFF);
                           $a = $rgb >> 24;
                           $new_pxl = imagecolorallocatealpha($source, $r, $g, $b, $a);
                           if ($new_pxl == false){
                               $new_pxl = imagecolorclosestalpha($source, $r, $g, $b, $a);
                           }
                           imagesetpixel($source,$x,$y,$new_pxl);
                           ++$x;
                       }
                       ++$y;
                   }
                   return true;
               break;
               case 1:
                   $y = 0;
                   while($y<$max_y) {
                       $x = 0;
                       while($x<$max_x){
                           $rgb = imagecolorat($source,$x,$y);
                           $a = $rgb >> 24;
                           $r = ((($rgb >> 16) & 0xFF)*0.299)+((($rgb >> 8) & 0xFF)*0.587)+(($rgb & 0xFF)*0.114);
                           $new_pxl = imagecolorallocatealpha($source, $r, $r, $r, $a);
                           if ($new_pxl == false){
                               $new_pxl = imagecolorclosestalpha($source, $r, $r, $r, $a);
                           }
                           imagesetpixel($source,$x,$y,$new_pxl);
                           ++$x;
                       }
                       ++$y;
                   }
                   return true;
               break;
               case 2:
                   $y = 0;
                   while($y<$max_y) {
                       $x = 0;
                       while($x<$max_x){
                           $rgb = imagecolorat($source,$x,$y);
                           $r = (($rgb >> 16) & 0xFF) + $arg1;
                           $g = (($rgb >> 8) & 0xFF) + $arg1;
                           $b = ($rgb & 0xFF) + $arg1;
                           $a = $rgb >> 24;
                             $r = ($r > 255)? 255 : (($r < 0)? 0:$r);
                           $g = ($g > 255)? 255 : (($g < 0)? 0:$g);
                           $b = ($b > 255)? 255 : (($b < 0)? 0:$b);
                           $new_pxl = imagecolorallocatealpha($source, $r, $g, $b, $a);
                           if ($new_pxl == false){
                               $new_pxl = imagecolorclosestalpha($source, $r, $g, $b, $a);
                           }
                           imagesetpixel($source,$x,$y,$new_pxl);
                           ++$x;
                       }
                       ++$y;
                   }
                   return true;
               break;
               case 3:
                   $contrast = pow((100-$arg1)/100,2);
                   $y = 0;
                   while($y<$max_y) {
                       $x = 0;
                       while($x<$max_x){
                           $rgb = imagecolorat($source,$x,$y);
                           $a = $rgb >> 24;
                           $r = (((((($rgb >> 16) & 0xFF)/255)-0.5)*$contrast)+0.5)*255;
                           $g = (((((($rgb >> 8) & 0xFF)/255)-0.5)*$contrast)+0.5)*255;
                           $b = ((((($rgb & 0xFF)/255)-0.5)*$contrast)+0.5)*255;
                           $r = ($r > 255)? 255 : (($r < 0)? 0:$r);
                           $g = ($g > 255)? 255 : (($g < 0)? 0:$g);
                           $b = ($b > 255)? 255 : (($b < 0)? 0:$b);
                           $new_pxl = imagecolorallocatealpha($source, $r, $g, $b, $a);
                           if ($new_pxl == false){
                               $new_pxl = imagecolorclosestalpha($source, $r, $g, $b, $a);
                           }
                           imagesetpixel($source,$x,$y,$new_pxl);
                           ++$x;
                       }
                       ++$y;
                   }
                   return true;
               break;
               case 4:
                   $x = 0;
                   while($x<$max_x){
                       $y = 0;
                       while($y<$max_y){
                           $rgb = imagecolorat($source, $x, $y);
                           $r = (($rgb >> 16) & 0xFF) + $arg1;
                           $g = (($rgb >> 8) & 0xFF) + $arg2;
                           $b = ($rgb & 0xFF) + $arg3;
                           $a = $rgb >> 24;
                           $r = ($r > 255)? 255 : (($r < 0)? 0:$r);
                           $g = ($g > 255)? 255 : (($g < 0)? 0:$g);
                           $b = ($b > 255)? 255 : (($b < 0)? 0:$b);
                           $new_pxl = imagecolorallocatealpha($source, $r, $g, $b, $a);
                           if ($new_pxl == false){
                               $new_pxl = imagecolorclosestalpha($source, $r, $g, $b, $a);
                           }
                           imagesetpixel($source,$x,$y,$new_pxl);
                           ++$y;
                           }
                       ++$x;
                   }
                   return true;
               break;
               case 5:
                   return imageconvolution($source, array(array(-1,0,-1), array(0,4,0), array(-1,0,-1)), 1, 127);
               break;
               case 6:
                   return imageconvolution($source, array(array(1.5, 0, 0), array(0, 0, 0), array(0, 0, -1.5)), 1, 127);
               break;
               case 7:
                   return imageconvolution($source, array(array(1, 2, 1), array(2, 4, 2), array(1, 2, 1)), 16, 0);
               break;
               case 8:
           for($y = 0; $y<$max_y; $y++) {
               for ($x = 0; $x<$max_x; $x++) {
                     $flt_r_sum = $flt_g_sum = $flt_b_sum = 0;
                   $cpxl = imagecolorat($source, $x, $y);
                   for ($j=0; $j<3; $j++) {
                       for ($i=0; $i<3; $i++) {
                           if (($j == 1) && ($i == 1)) {
                               $flt_r[1][1] = $flt_g[1][1] = $flt_b[1][1] = 0.5;
                           } else {
                               $pxl = imagecolorat($source, $x-(3>>1)+$i, $y-(3>>1)+$j);

                               $new_a = $pxl >> 24;
                               //$r = (($pxl >> 16) & 0xFF);
                               //$g = (($pxl >> 8) & 0xFF);
                               //$b = ($pxl & 0xFF);
                               $new_r = abs((($cpxl >> 16) & 0xFF) - (($pxl >> 16) & 0xFF));
                               if ($new_r != 0) {
                                   $flt_r[$j][$i] = 1/$new_r;
                               } else {
                                   $flt_r[$j][$i] = 1;
                               }

                               $new_g = abs((($cpxl >> 8) & 0xFF) - (($pxl >> 8) & 0xFF));
                               if ($new_g != 0) {
                                   $flt_g[$j][$i] = 1/$new_g;
                               } else {
                                   $flt_g[$j][$i] = 1;
                               }

                               $new_b = abs(($cpxl & 0xFF) - ($pxl & 0xFF));
                               if ($new_b != 0) {
                                   $flt_b[$j][$i] = 1/$new_b;
                               } else {
                                   $flt_b[$j][$i] = 1;
                               }
                           }

                           $flt_r_sum += $flt_r[$j][$i];
                           $flt_g_sum += $flt_g[$j][$i];
                           $flt_b_sum += $flt_b[$j][$i];
                       }
                   }

                   for ($j=0; $j<3; $j++) {
                       for ($i=0; $i<3; $i++) {
                           if ($flt_r_sum != 0) {
                               $flt_r[$j][$i] /= $flt_r_sum;
                           }
                           if ($flt_g_sum != 0) {
                               $flt_g[$j][$i] /= $flt_g_sum;
                           }
                           if ($flt_b_sum != 0) {
                               $flt_b[$j][$i] /= $flt_b_sum;
                           }
                       }
                   }

                   $new_r = $new_g = $new_b = 0;

                   for ($j=0; $j<3; $j++) {
                       for ($i=0; $i<3; $i++) {
                           $pxl = imagecolorat($source, $x-(3>>1)+$i, $y-(3>>1)+$j);
                           $new_r += (($pxl >> 16) & 0xFF) * $flt_r[$j][$i];
                           $new_g += (($pxl >> 8) & 0xFF) * $flt_g[$j][$i];
                           $new_b += ($pxl & 0xFF) * $flt_b[$j][$i];
                       }
                   }

                   $new_r = ($new_r > 255)? 255 : (($new_r < 0)? 0:$new_r);
                   $new_g = ($new_g > 255)? 255 : (($new_g < 0)? 0:$new_g);
                   $new_b = ($new_b > 255)? 255 : (($new_b < 0)? 0:$new_b);
                   $new_pxl = ImageColorAllocateAlpha($source, (int)$new_r, (int)$new_g, (int)$new_b, $new_a);
                   if ($new_pxl == false) {
                       $new_pxl = ImageColorClosestAlpha($source, (int)$new_r, (int)$new_g, (int)$new_b, $new_a);
                   }
                   imagesetpixel($source,$x,$y,$new_pxl);
               }
           }
           return true;
               break;
               case 9:
                   return imageconvolution($source, array(array(-1,-1,-1),array(-1,9,-1),array(-1,-1,-1)), 1, 0);
               break;
               case 10:
                   return imageconvolution($source, array(array(1,1,1),array(1,$arg1,1),array(1,1,1)), $arg1+8, 0);
               break;
           }
        }
}
?>
