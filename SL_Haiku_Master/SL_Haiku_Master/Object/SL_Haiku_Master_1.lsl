// :CATEGORY:HTTP
// :NAME:SL_Haiku_Master
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:785
// :NUM:1073
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// PHP Script
// :CODE:
<?php

// Even items are words. Odd items represent the number of syllables.

$nouns = array("griefer","2","flying car","3","camping chair","3","flexible prim","4","prim", "1", "welcome center","4", "orient island","5","Linden Lab", "3", "Linden","2", "inner core", "3", "pose ball", "5", "avatar", "3", "sim", "1", "script", "1", "hardware lighting", "4"); // Set the variable $nouns to words and syllables.

$verbs = array("Lagging","2","Flying", "2", "Building together","5","Teleporting", "4", "Pose balling", "3", "Editing appearance", "6"); // Set the variable $verbs to words and syllables.

$adv = array("in the Metaverse", "5", "slowly", "2", "well", "1", "in the air", "3", "very quickly", "4", "", "0", "with great speed", "3"); // Set the variable $adv to words and syllables.

$adj = array("so gorgeous","3","sexy cool","3","lonely","2","cool", "1", "electric", "3", "stunning", "2", "glowing", "3", "fetid inner", "4", "beautiful", "3", "abuzz", "2", "colourful", "3", "turquoise", "2", "", "0"); // Set the variable $adj to words and syllables.



function makehaiku1() { // When makehaiku1() is used\xC9

    while(1) { // repeat indefinitely.

        global $nouns, $adj; // Use the variables defined at the top.

        $x = mt_rand(0, count($nouns)); // Set $x to a random number between 0 and the number of items in $nouns.

        if ($x % 2 == 1) { // If $x is odd\xC9

            $x--; // subtract 1 from $x.

        }

        $y = mt_rand(0, count($adj)); // Set $y to a random number between 0 and the number of items in $adj.

        if ($y % 2 == 1) { // If $y is odd\xC9

            $y--; // subtract 1 from $y.

        }

        $haiku1 = "The ".$adj[$y]." ".$nouns[$x]; // Set $haiku1 to "The (adj) (noun)." This will be used as the first line of the haiku.

        if (1 + $nouns[$x+1] + $adj[$y+1] == 5) { // If there are 5 syllables in $haiku1\xC9

            break; // exit the repeating.

        }

    }

    return $haiku1; // Pass the value of $haiku1 to whatever is using makehaiku1().

}

function makehaiku2() { // When makehaiku2() is used\xC9

    while(1) { // repeat indefinitely.

        global $verbs, $adv; // Use the variables defined at the top.

        $a = mt_rand(0, count($verbs)); // Set $a to a random number between 0 and the number of items in $verbs.

        if ($a % 2 == 1) { // If $a is odd\xC9

            $a--; // subtract 1 from $a.

        }

        $z = mt_rand(0, count($adv)); // Set $z to a random number between 0 and the number of items in $verbs.

        if ($z % 2 == 1) { // If $z is odd\xC9

            $z--; // subtract 1 from $z.

        }

        $haiku2 = $verbs[$a]." ".$adv[$z]; // Set $haiku2 to "(verb) (adverb)."

        if ($verbs[$a+1] + $adv[$z+1] == 7) { // If there are 7 syllables in $haiku2\xC9

            break; // exit the repeating.

        }

    }

    return $haiku2; // Pass the value of $haiku2 to whatever is using makehaiku2().

}

function makehaiku3() { // When makehaiku3() is used\xC9

    while(1) { // repeat indefinately.

        global $adj; // Use the variables defined at the top.

        $y = mt_rand(1, count($adj)); // Set $y to a random number between 0 and the number of items in $adj.

        if ($y % 2 == 1) { // If $y is odd\xC9

            $y--; // subtract 1 from $y.

        }

        $haiku3 = "It is ".$adj[$y]; // Set $haiku3 to "It is (adjective)."

        if (2 + $adj[$y+1] == 5) { // If there are 5 syllables in $haiku3\xC9

            break; // exit the repeating.

        }

    }

    return $haiku3; // Pass the value of $haiku3 to whatever is using makehaiku3().

}

$haiku = makehaiku1()." - ".makehaiku2()." - ".makehaiku3(); // Display the first line, the second line, and the third line.

echo($haiku);

?> 
