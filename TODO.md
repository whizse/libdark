Not all apps use XMapWindow. We should probably hook XCreateWindow
instead.

Look at how libstrange handles dlopen.

Apps that dlopen libX11.so themselves don't work. This seems to to
include SDL, Wine, and some Qt5 apps. Potential testcases include the
Arduino IDE, vcmilauncher, qapitrace and winecfg.

For more see apt-rdepends --state-follow=Installed --state-show=Installed -r libqt5widgets5

SDL uses dlopen in SDL_x11sym.h and calls it's own override X11_XOpenDisplay

Emacs uses XMapWindow for every menu, so maybe hook something else?
  
Adwaita, Arcs and possibly other themes with gtk-2.0 versions are
broken when GTK2_RC_FILES is overriden. File a bug? 
https://gitlab.gnome.org/GNOME/gnome-themes-extra/issues?scope=all&utf8=%E2%9C%93&state=opened

--- /usr/share/themes/Adwaita-dark/gtk-2.0/main.rc	2018-03-22 18:36:35.000000000 +0100
+++ /usr/share/themes/Adwaita-dark/gtk-2.0/main.rc.mod	2018-08-17 19:14:53.347692164 +0200
@@ -5,7 +5,7 @@
 # which is also mostly done in this file. Sadly not all of them can be overcome
 # so there will always be a visible difference between the GTK+ 2 and 3 theme.
 
-style "default" {
+style "standard-default" {
 
   xthickness = 1
   ythickness = 1
@@ -2474,7 +2474,7 @@ style "disable_separator" {
 # by its own but also less bug-prune and more consistent. However there is some
 # widget specific stuff that needs to be taken care of, which is the point of
 # every other style below.
-class "GtkWidget" style "default"
+class "GtkWidget" style "standard-default"
 
  ######################################
  # Override padding, style and colour #
