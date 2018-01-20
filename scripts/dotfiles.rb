#!/usr/bin/env ruby
# symlink all the dotfiles

$scripts_dir = File.dirname(__FILE__)
$base_dir = File.expand_path('..', $scripts_dir)
$file_dir = File.join($base_dir, 'files')
$dest_dir = File.expand_path('~')

puts "file dir: #{$file_dir}"
puts "dest dir: #{$dest_dir}"

Dir.glob(File.join($file_dir, '*')).each do |path|
  dotname = ".#{File.basename(path)}"
  dest = File.join($dest_dir, dotname)

  if File.exist? dest
    puts "#{dest} exists! skipping"
  else
    puts "#{path} -> #{dest}"
    File.symlink(path, dest)
  end
end
