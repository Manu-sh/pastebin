require 'uri'
require 'net/http'
require 'nokogiri'

require_relative 'HttpUtils.rb'

module PasteBin

	# cached pastebin opt
	PASTE_BIN_OPT = 'pastebin_opt.rb'
	PASTE_BIN_URL = 'https://pastebin.com'

	# define some static methods into a singleton class (required to mark __init & __parse_opt_from_dom as private)
	class << self

		@@loaded        = false;
		@@format_opt    = nil
		@@expire_opt    = nil
		@@visibility_opt = nil	
	
		def __parse_opt_from_dom()

			puts "Attempting to generate #{PASTE_BIN_OPT}..."

			dom = Nokogiri::HTML(HttpUtils::get_response(PASTE_BIN_URL).body)
			paste_format = nil, paste_expire_date = nil, paste_private = nil, threads = []
	
			threads << Thread.new do 
	
				paste_format = Hash[ dom.css('#myform select[name="paste_format"] > option').reject {|e|
					tmp = e.children.to_s.upcase
					tmp.include?('(PRO MEMBERS ONLY)') || tmp.include?('------')
				}.map { |e|
					tmp = e.children.to_s.upcase
					tmp = tmp.gsub(' ', '_').gsub('+', '_PLUS').gsub('#', '_SHARP').gsub(/[^\w]/, '')
					[tmp, e[:value].to_s]
				}];
	
			end
			
			threads << Thread.new do

				paste_expire_date = Hash[ dom.css('#myform select[name="paste_expire_date"] > option').map { |e|
					tmp = e.children.to_s.upcase
					tmp = tmp.gsub(' ', '_').gsub(/[^\w]/, '')
					[tmp, e[:value].to_s]
				}];
	
			end
	
			threads << Thread.new do 
			
				paste_private = Hash[ dom.css('#myform select[name="paste_private"] > option').map { |e|
					tmp = e.children.to_s.upcase
					tmp = tmp.gsub(' ', '_').gsub(/[^\w]/, '')
					[tmp, e[:value].to_s]
				}];
	
			end
	
			threads.each { |t| t.join }
	
			File.open(PASTE_BIN_OPT, File::TRUNC|File::WRONLY|File::CREAT, 0644) { |f|
				f.print "$paste_format=", paste_format, "\n\n"
				f.print "$paste_expire_date=", paste_expire_date, "\n\n"
				f.print "$paste_private=", paste_private, "\n\n"
			}

			puts "#{PASTE_BIN_OPT} was successfully updated"
	
		end

		def __init()

			return if @@loaded

			# generate the opt file if not exist
			__parse_opt_from_dom() unless File.exist? PASTE_BIN_OPT

			# load the opt file into memory ($paste_format, $paste_expire_date, $paste_private)
			load PASTE_BIN_OPT unless @@loaded
			@@format_opt    = $paste_format.each_key.map {|k| k }
			@@expire_opt    = $paste_expire_date.each_key.map {|k| k }
			@@visibility_opt = $paste_private.each_key.map {|k| k }
			@@loaded        = true

		end

		def format_opt()    __init(); return @@format_opt; end
		def expire_opt()    __init(); return @@expire_opt; end
		def visibility_opt() __init(); return @@visibility_opt; end

		private :__init, :__parse_opt_from_dom;
	end

	def self.send(title, content, format_opt = 'NONE', expire_opt = '10_MINUTES', visibility_opt = 'UNLISTED')

		__init()

		response  = HttpUtils::get_response(PASTE_BIN_URL)

		####### HDR

		# store some required cookie
		mcookie  = Hash[response['set-cookie'].scan( /(__cfduid|PHPSESSID)=([^;]*);/ )]

		####### DOM

		# get the value of attribute 'value' from DOM (required later as part of multipart-form-data)
		# <input type="hidden" name="csrf_token_post" value="MTUzODY4MjkxOVg4V0c4TTVNSEk1OHVzNGx6cTZGTkpuSHlEd2F4dDF6">

		dom             = Nokogiri::HTML(response.body)
		csrf_token_post = dom.at_css('input[name="csrf_token_post"]')[:value]

		# get the path at which send the post request
		# <form class="paste_form" id="myform" enctype="multipart/form-data" name="myform" method="post" action="/post.php" ... 
		path = dom.at_css('#myform')[:action]

		####### POST

		uri  = URI(PASTE_BIN_URL + path)
		req  = Net::HTTP::Post.new(uri.request_uri)

		{ # override some hdr entries
			'cookie' => "__cfduid=#{mcookie['__cfduid']}; PHPSESSID=#{mcookie['PHPSESSID']};"	
		}.each { |k, v| req[k] = v; }

		####### MULTIPART

		req.set_form(
			[
				['csrf_token_post',   csrf_token_post],
				['submit_hidden',     'submit_hidden'],
				['paste_code',        content        ], 

				['paste_format',      $paste_format.fetch(format_opt)      ], 
				['paste_expire_date', $paste_expire_date.fetch(expire_opt) ], 
				['paste_private',     $paste_private.fetch(visibility_opt)  ],
				['paste_name',        title]

			], 'multipart/form-data');


		####### SEND POST

		# enable ssl if uri.scheme == https	
		Net::HTTP.start(uri.host, uri.port, { :use_ssl => uri.scheme == 'https' } ) { |http|

			case (res = http.request(req))
				# when Net::HTTPSuccess
					# res.each_header {|key,value| puts "#{key} = #{value}" }
					# puts
				when Net::HTTPRedirection
					location = URI.join(PASTE_BIN_URL, res['location'])
					return "#{location}"
				else
					raise RuntimeError.new("#{res} #{res.value}")
			end
		}

	end

	def self.send_file(fpath, expire_opt = '10_MINUTES', visibility_opt = 'UNLISTED')

		File.open(fpath) {|f|

			format_opt = nil

			case (basename = File.basename(f.path))
				when /.*\.(cpp|cc|cxx|hpp|hxx)/i; format_opt = 'C_PLUS_PLUS'
				when /.*\.(css|less)/i;           format_opt = 'CSS'
				when /.*\.(c|h)/i;                format_opt = 'C'
				when /.*\.py/i;                   format_opt = 'PYTHON'
				when /.*\.rb/i;                   format_opt = 'RUBY'
				when /.*\.rs/i;                   format_opt = 'RUST'
				when /.*\.pl/i;                   format_opt = 'PERL'
				when /.*\.php/i;                  format_opt = 'PHP'
				when /.*\.js/i;                   format_opt = 'JAVASCRIPT'
				when /.*\.pl/i;                   format_opt = 'PERL'
				when /.*\.html/i;                 format_opt = 'HTML'
				when /.*\.sh/i;                   format_opt = 'BASH'
				when /.*\.java/i;                 format_opt = 'JAVA_5'
				when /.*\.tex/i;                  format_opt = 'LATEX'
				when /makefile/i;                 format_opt = 'MAKE'
				else
					warn 'cannot detect file type syntax hightlight disabled'
					format_opt = 'NONE'
			end

			return PasteBin.send(basename, f.readlines * '', format_opt, expire_opt, visibility_opt)

		}

	end

end
