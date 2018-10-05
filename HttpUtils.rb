require 'uri'
require 'net/http'

module HttpUtils

	# get only header (ignore don't read & map response body into memory)
	# usage: get_response_hdr(fetch(url)).to_hash

	def self.get_response(uri_str, hmap = {}, follow_redirection = true)

		uri = follow_redirection ? URI.parse(fetch(uri_str, hmap)) : URI.parse(uri_str)
		req = Net::HTTP::Get.new(uri)
		hmap.each {|k,v| req[k] = v }

		# enable ssl if uri.scheme == https
		Net::HTTP.start(uri.host, uri.port, { :use_ssl => uri.scheme == 'https' } ) do |http|
			http.request(req)
		end
	end

	# http://ruby-doc.org/stdlib-2.4.2/libdoc/net/http/rdoc/Net/HTTP.html
	# follow n redirection (which n is limit) and return the final url destination
	# hmap is the header map that will be used for send these request

	def self.fetch(uri_str, hmap = {}, limit = 10)

		raise(ArgumentError, 'err too many HTTP redirects') if limit == 0

		# wee need only of header
		case (response = get_response(uri_str, hmap, false))
			when Net::HTTPSuccess then
				return uri_str.to_s
			when Net::HTTPRedirection then

				# dump hdr
				response.each_header {|key,value| puts "#{key} = #{value}" }
				puts

				# get an absolute url from base url
				location = URI.join(uri_str, response['location']).to_s

				warn "redirected to #{location}"
				return fetch(location, hmap, limit - 1)
			else
				return response.value
		end
	end

	def self.boundary()
		return ('--' * 14) + Random.urandom(14).each_codepoint.map {|c| "%02x" % (c.ord%256) } * '';
	end

end