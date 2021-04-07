/*
Copyright (C) 2018 Sven Arvidsson

This file is part of libdark.

libdark is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

libdark is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with libdark.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>

/*
  Notes:
  
  Unsetting of the environment variables stops propagation of the dark
  theme if the app spawns another process. Such as starting a browser
  to open a link.
 
  Unsetting LD_PRELOAD potentially breaks if it's used to load other
  libraries. We should probably remove libdark.so from the value of
  LD_PRELOAD instead.

  Emacs, and potentially others, is a little bit too clever and uses
  the shell's original environment variables and not the process when
  spawning a new process. You can work around this by unsetting the
  theme variables in .emacs:

  (setenv "GTK_THEME" "")
  (setenv "GTK2_RC_FILES" "")
  
*/

int (*_XMapWindow)() = NULL;
Atom UTF8_STRING;
Atom _GTK_THEME_VARIANT;
const char *dark = "dark";

__attribute__ ((constructor))
void init(void) {
  setenv("GTK_THEME", "Adwaita:dark", 1);
  setenv("GTK2_RC_FILES", "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc", 1);
  /* fprintf(stderr, "In init.\n"); */

  unsetenv("LD_PRELOAD");
}

int XMapWindow(Display *dpy, Window w) {
  if (_XMapWindow == NULL ) {
    void *handle = dlopen("libX11.so.6", RTLD_LAZY);
    if (handle) {
      _XMapWindow = dlsym(handle, "XMapWindow");
      UTF8_STRING = XInternAtom(dpy, "UTF8_STRING", 0);
      _GTK_THEME_VARIANT = XInternAtom(dpy, "_GTK_THEME_VARIANT", 0);
      /* fprintf(stderr, "XMapWindow hooked!\n"); */

      unsetenv("GTK_THEME");
      unsetenv("GTK2_RC_FILES");
      dlclose(handle);
    }
  }
  /* fprintf(stderr, "XMapWindow called!\n"); */
  
  XChangeProperty(dpy, w, _GTK_THEME_VARIANT, UTF8_STRING, 8,
		  PropModeReplace, (unsigned char*)dark, 4);

  return _XMapWindow(dpy, w);
}
