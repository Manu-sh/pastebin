require 'uri'
require 'net/http'
require 'nokogiri'

require_relative 'HttpUtils.rb'

module PasteBin

	# cached pastebin opt
	PASTE_BIN_OPT = 'pastebin_opt.rb'
	PASTE_BIN_URL = 'https://pastebin.com'

	# define some static methods into a singleton class (required to mark __parse_opt_from_dom as private)
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

			puts "#{PASTE_BIN_OPT} was successfully generated"
	
		end

		def init()

			return if @@loaded

			# generate the opt file if not exist
			__parse_opt_from_dom() unless File.exist? PASTE_BIN_OPT

			# load the opt file into memory ($paste_format, $paste_expire_date, $paste_private)
			load PASTE_BIN_OPT unless @@loaded
			@@format_opt    = $paste_format.each_key.sort.map      {|k| k }
			@@expire_opt    = $paste_expire_date.each_key.sort.map {|k| k }
			@@visibility_opt = $paste_private.each_key.sort.map    {|k| k }
			@@loaded        = true

		end

		def format_opt()     init(); return @@format_opt; end
		def expiration_opt()     init(); return @@expire_opt; end
		def visibility_opt() init(); return @@visibility_opt; end

		private :__parse_opt_from_dom;
	end

	def self.send(title, content, format_opt = 'NONE', expire_opt = '10_MINUTES', visibility_opt = 'UNLISTED')

		init()

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

	def self.send_file(fpath, format = '', expire = '10_MINUTES', visibility = 'UNLISTED')

		File.open(fpath) {|f|

			basename = File.basename(f.path)

			case (basename)

				when /.*\.(cpp|cc|cxx|hpp|hxx)/i; format = 'C_PLUS_PLUS'
				when /.*\.(css|less)/i;           format = 'CSS'
				when /.*\.(c|h)/i;                format = 'C'
				when /.*\.py/i;                   format = 'PYTHON'
				when /.*\.rb/i;                   format = 'RUBY'
				when /.*\.rs/i;                   format = 'RUST'
				when /.*\.pl/i;                   format = 'PERL'
				when /.*\.php/i;                  format = 'PHP'
				when /.*\.js/i;                   format = 'JAVASCRIPT'
				when /.*\.pl/i;                   format = 'PERL'
				when /.*\.html/i;                 format = 'HTML'
				when /.*\.sh/i;                   format = 'BASH'
				when /.*\.java/i;                 format = 'JAVA_5'
				when /.*\.tex/i;                  format = 'LATEX'
				when /makefile/i;                 format = 'MAKE'
				else
					warn 'cannot detect file type syntax hightlight disabled'
					format = 'NONE'

			end if format.empty?

			return PasteBin.send(basename, f.readlines * '', format, expire, visibility)

		}

	end

end
