# autoshot.rb

Watch a directory and scp new files to a host that
is running a webserver. Only works on OSX, could be
made to work on other platforms with alternatives
to `rb-fsevent` (and maybe `scp`?).

## Warning

This script will overwrite your clipboard when
you take a screenshot!

## Dependencies

- `ruby` (only tested on 1.9.3)
- `rb-fsevent` (only tested with 0.9.2)

## Usage

Configure OSX to place screenshots somewhere out of the way:

    defaults write com.apple.screencapture location '~/Pictures/Screenshots'
    killall SystemUIServer

Change the values below in this script such that:

- 'scp' is an `scp(1)` compatible target
    e.g `user@host:/var/www/mysite/img/screenshots`
- 'url' is the hostname the files will be available at
    e.g `http://mysite.com/img/screenshots`
- 'watch_dir' is the directory to watch
    e.g `~/Pictures/Screenshots`

Now run it either plainly:

    ruby autoshot.rb

<small>Files not already processed will be uploaded
(so be careful because your clipboard will only
get the last one).</small>

Or faux-daemonize, set 'debug' to false in CONFIG, and:

    ruby autoshot.rb &
