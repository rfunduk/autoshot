#!/usr/bin/env ruby

# autoshot.rb
#
# Ryan Funduk (ryanfunduk.com)
# Licensed under WTFPL (http://sam.zoy.org/wtfpl)
#
# https://github.com/rfunduk/autoshot
#
# Warnings:
#   This writes a list of already processed files directly
#   into this script (yes, *this file*).
#
#   This script will overwrite your clipboard when
#   you take a screenshot!

require 'rb-fsevent'
require 'digest/sha1'

CONFIG = {
  debug: true,
  scp: "user@host.com:/path/to/web/accessible/dir",
  url: "http://host.com/path",
  watch_dir: File.expand_path("~/Pictures/Screenshots")
}

$info_pos = DATA.pos

def sync(*args)
  DATA.reopen( __FILE__, 'r' )
  DATA.seek $info_pos
  processed = DATA.read.split("\n").reject { |f| f.strip.length == 0 }
  all = Dir.glob( File.join(CONFIG[:watch_dir], '*') )

  (all - processed).each do |file|
    filename = File.basename( file )
    hash = Digest::SHA1.hexdigest( filename )
    ext = File.extname( file )
    new_name = "#{hash}#{ext}"

    print "Processing #{filename}... " if CONFIG[:debug]
    `scp '#{file}' #{CONFIG[:scp]}/#{new_name}`
    `echo #{CONFIG[:url]}/#{new_name} | pbcopy`
    print "DONE\n" if CONFIG[:debug]

    processed << file
  end

  DATA.reopen( __FILE__, 'a+' )
  DATA.truncate( $info_pos )
  DATA.puts processed.join("\n")
  DATA.flush
end

puts "Started..." if CONFIG[:debug]

sync()

watcher = FSEvent.new
watcher.watch(
  CONFIG[:watch_dir],
  latency: 1, no_defer: true,
  &method(:sync)
)
watcher.run

puts "Quitting..." if CONFIG[:debug]

__END__
