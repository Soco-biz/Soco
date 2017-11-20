module ApplicationHelper
require "uri"
	def text_url_to_link text
		URI.extract(text, ['http']).uniq.each do |url|
			sub_text = ""
		    sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"
		    text.gsub!(url, sub_text)
		end
		return text
	end
	def page_title
		title = "Soco β"
	    title = "#{@page_title}" + ' - ' + title if @page_title
	    title
	end
	def hbr(target)
	target = html_escape(target)
	target.gsub(/\r\n|\r|\n/, " <br /> ").gsub(/https?:\/\/[\S]+/){"\<a class='post_link' href\=\"#{$&}\"target\=\"new\">#{$&}\<\/a\>"}
	end
end

