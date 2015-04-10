#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter,
# but nudges 0.5% of the bytes updwards to produce demonstrable skew.

# This case demonstrates the utility of the "runs" test.

require 'digest/md5'

Signal.trap("INT") { exit(0) }

limit = ARGV.first.to_i
bytes_max = limit ? limit : 0
bytes = 0

i = 0
loop do
  print Digest::MD5.digest([i].pack('Q>'))
  md5 = Digest::MD5.digest([i].pack('Q<'))
  msb = md5[0].ord
  md5[0] = ('%08b' % msb).reverse.to_i(2).chr if msb < 43
  print md5 rescue break
  bytes += md5.length
  break if bytes > bytes_max
  i += 1
end
