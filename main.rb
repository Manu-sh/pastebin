#!/usr/bin/ruby

require 'getoptlong'

require_relative 'HttpUtils.rb'
require_relative 'PasteBin.rb'

PROG_NAME=File.basename($0)
PasteBin::init()

def fmt_opt(a, width, rjust)
	rjust = ' ' * rjust;
	return (a * ', ').gsub!(/(.{1,#{width}})(\s+|\Z)/, "#{rjust}\\1\n")
end

opts = GetoptLong.new(
	[ '--help',        '-h', GetoptLong::NO_ARGUMENT ],
	[ '--format',      '-f', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--expiration',  '-e', GetoptLong::OPTIONAL_ARGUMENT ],
	[ '--visibility',  '-v', GetoptLong::OPTIONAL_ARGUMENT ]
)

# default beavior 
cmd_opt = {
	format: '',
	expiration: '10_MINUTES',
	visibility: 'PUBLIC'
}

USAGE = <<EOF
#{PROG_NAME} usage:
	-h, --help
		this help

	-f, --format
		manually specify the format (used for syntax hight-light),
		by default #{PROG_NAME} shall try to recognize it based on file suffix)

#{fmt_opt(PasteBin.format_opt, 78, 20)}
	-e, --expiration
		paste expiration, default is 10 minutes

#{fmt_opt(PasteBin.expiration_opt, 78, 20)}
	-v, --visibility
		paste exposure, default is public

#{fmt_opt(PasteBin.visibility_opt, 78, 20)}
	examples:
		#{PROG_NAME} -f c_plus_plus ~/file
		#{PROG_NAME} -e 1_day -v unlisted -f bash ~/.bashrc

	see also: #{PasteBin::PASTE_BIN_URL}/faq
EOF

opts.each do |option, arg|

	case option

		when '--help'
			puts(USAGE)
			exit(0)
		when '--format'
			cmd_opt[:format] = arg.to_s.upcase unless arg.empty?
		when '--expiration'
			cmd_opt[:expiration] = arg.to_s.upcase unless arg.empty?
		when '--visibility'
			cmd_opt[:visibility] = arg.to_s.upcase unless arg.empty?
		else
			puts(USAGE)
			exit(1)
	end

end

puts "type #{PROG_NAME} -h to get an help" if ARGV.empty?

# getoptlong automatically unshift options & relative arguments from ARGV
# so each remaining ARGV is a file to upload on pastebin.com

ARGV.each { |f| raise(ArgumentError, "file #{f} not found") unless File.exist?(f) && File.readable?(f) }
ARGV.each { |f| puts PasteBin.send_file(f, cmd_opt[:format], cmd_opt[:expiration], cmd_opt[:visibility]) }
