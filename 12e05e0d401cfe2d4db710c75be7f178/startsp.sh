#!/bin/sh
Xvfb :1 &amp; xvfb-run /usr/bin/sonic-pi 2 &gt;/dev/null &amp;