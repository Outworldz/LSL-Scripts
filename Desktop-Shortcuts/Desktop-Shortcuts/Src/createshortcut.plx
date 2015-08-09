// :CATEGORY:Shortcut
// :NAME:Desktop-Shortcuts
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Shortcut
// :CREATED:2014-02-20 14:20:12
// :EDITED:2014-02-20
// :ID:1026
// :NUM:1595
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Desktop Shortcut creator script to write a landmark taken from a webserver form.
// :CODE:
=pod
// Perl for Server
=cut

#!perl.exe

#  author: Fred Beckhusen
# Perl  Server code to read a web form. It created a VB script that makes an Icon
# requires the Cpan module Template::Toolkit (' cpan Toolkit')
# this scritp reads form vars such as :
# Icon = N,  (Integer) that selects and icon from Windows/System32/SHELL32.dll.   You can view these by changing any ocon and looking inside Shell32.dll
# Name = (string) the name of the Icon on the desktop, default  Launch
# HotKey = (string) Ctrl + Shift + a Key, such as CTRL+SHIFT+F1
# nBits (integer) 32 or 64 for the viewer type. Currently, only Singularity supports 64 bits


BEGIN {
   $| = 1; # disable output buffering
   use CGI::Carp('fatalsToBrowser'); # always carp to the browser in case something goes wrong, goes wrong
}

use strict;
use warnings;

use CGI qw(:standard);  # Load CGI module
my $Input = CGI->new(); # get access to web forms


print $Input->header( -type => 'text/plain',             # just text
                      -charset => 'utf-8',               # allow Unicode names
                      -attachment => 'InstallIcon.vbs',  # name for the shortcut
                    );

use Template;  # get access to Template::Toolkit
my $tt = Template->new( ) or die $Template::ERROR;

# Open the file and change all the [% vars %] to this hash
$tt->process('icon.tt.vbs', {
   hover       => 'Launch Viewer',                       # the name of the shortcut
   icon        => $Input->param('Icon') || 34,           # Icon look and feel
   name        => $Input->param('Name') || 'Launch',     # default name
   hotkey      => $Input->param('HotKey') || 'Ctrl+F1',  # hotkey
   nBits       => $Input->param('nBits') || 32 ,         # 32 or 64
});
