#!/usr/bin/env ruby

# helper class to convert blkid entries
# to fstab entries
class BlkidDrive
  attr_reader :dev
  attr_reader :uuid

  def initialize(str)
    @str = str
    @dev, _, rest = @str.partition(':')
    split_tags(rest.chomp)
  end

  def comment
    "# #{@dev}"
  end

  def fstab(mount, options: 'defaults', pass: 2)
    "UUID=#{@uuid} #{mount} #{@type} #{options} 0 #{pass}"
  end

  private
  def split_tags(str)
    str.scan(/[A-Z_]+="[^"]+"/) do |s|
      t,v = s.split('=')
      instance_variable_set("@#{t.downcase}", v.delete('"'))
    end
  end
end

# begin script
if `whoami`.chomp != 'root'
  abort "Error: Must be root to run script"
end

blkid = `blkid`
fstab = `cat /etc/fstab`
mounts = `mount`
base = '/media/disk'
num = 1

dirs = []
lines = []

puts "Parsing blkid entries.."
blkid.each_line do |l|
  d = BlkidDrive.new(l.chomp)

  if fstab.include? d.uuid
    puts "#{d.uuid} (#{d.dev}) already in fstab, skipping.."
    next
  end

  mount = nil
  loop do
    mount = "#{base}#{num}"
    num += 1
    dirs << mount unless File.exist? mount
    break unless mounts.include? mount
  end

  entries = Dir.entries(mount) - ['.', '..']
  abort "Error: #{mount} is not empty!" unless entries.empty?

  puts "Will mount #{d.uuid} (#{d.dev}) to #{mount}.."
  lines << d.comment
  lines << d.fstab(mount)
end

dirs.each do |d|
  puts "Making directory #{d}.."
  system("mkdir -p #{d}")
end

puts "Modifying /etc/fstab.."
File.open('/etc/fstab', 'a') do |f|
  lines.each { |l| f.puts l }
end

puts "Re-mounting /etc/fstab.."
system("mount -a")
