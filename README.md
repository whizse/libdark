# libdark #

Simple `LD_PRELOAD` shim that requests a dark theme by setting
`GTK_THEME`, `GTK2_RC_FILES` and the X window property `_GTK_THEME_VARIANT`.

Uses hardcoded values for theme, edit the source if you want something
besides the default Adwaita.

Does not work with anything that itself uses dlopen to find
libX11.so. Examples include Wine and SDL.

# Usage #

    sudo make install
    LD_PRELOAD=libdark.so app

# Notes #
The usual caveats apply, software WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. LD_PRELOAD'ing
random code can lead to badness. Don't blame me if libdark crashes
your app, eats your data, or elopes with your husband!

## Emacs ##
Emacs, and potentially other applications, uses the shell's original
environment variables and not the ones set in the process when
spawning a new one, leading to any apps launched by Emacs inheriting
the dark theme. You can work around this by unsetting the theme
variables in .emacs:

    (setenv "GTK_THEME" "")
    (setenv "GTK2_RC_FILES" "")

## GTK2 ##
Adwaita and some others have a bug in the gtk-2.0 theme that fails to
override the theme from the environment. The following change needs to
be applied:


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

