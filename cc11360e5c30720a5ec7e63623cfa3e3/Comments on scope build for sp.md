I built QScintilla adding the line `CONFIG += c++11` to qscintilla.pro
checked linking using `otool -L libqscintilla2.12.dylib` to check for
/usr/lib/libc++.1.dylib showing correct library used.

I used the install_name_tool as described in the current Install-Mac.md document

I built and installed qwt as per answer 1 in `stackoverflow.com/questions/18588418/install-and-use-qwt-under-mac-os-x`
NB make sure you copy the qwt framework to /Library/Frameworks on your Mac
Also amend the file `qwtbuild.pri` by adding `CONFIG += c++11` before building to ensure that the correct library is used.

I used brew install boost to install the boost libraries. I used the libboost.pc file that @factoid produced  here `https://gist.github.com/Factoid/7c187e28cc7c5c5310cdd60c4460b180`

```mkdir -p /usr/local/share/pkgconfig
cp /path/to/your/libboost.pc /usr/local/share/pkgconfig/libboost.pc```

check that pkg-config can see libboost using `pkg-config --cflags libboost`

I used the existing methods for installing libqscintilla2.12.0.0.dylib rather than letting qt find it as @factoid proposes
ie put in explicit paths in mac-build-app
