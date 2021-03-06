def mosconsv(words,from,til)
  result = []
  base_url = "http://mosconsv.ru"
  
  (from..til).each do |date|
    url  = base_url+"/ru/concert-date.aspx?sel_date=#{date.to_s}"
    html = open(url).read
    doc  = Nokogiri::HTML(html)
    (doc.css('div[class="center-conc-hall-event-item-title"]')>('a')).each do |event|
      local_url  = base_url+event.attr('href')
      local_html = open(local_url).read
      local_doc  = Nokogiri::HTML(local_html)
      item = local_doc.at_css('div[class="afisha-part-body"]').inner_text
      words.each do |word|
	if item.include? word
	  result << local_url
	  puts local_url
	  break
	end
      end
    end
  end
end

def events_with(words,from,til)
  result = []
  base_url = "http://mosconsv.ru"
  
  (from..til).each do |date|
    url  = base_url+"/ru/concert-date.aspx?sel_date=#{date.to_s}"
    html = open(url).read
    doc  = Nokogiri::HTML(html)
    (doc.css('div[class="center-conc-hall-event-item-title"]')>('a')).each do |event|
      local_url  = base_url+event.attr('href')
      local_html = open(local_url).read
      local_doc  = Nokogiri::HTML(local_html)
      item = local_doc.at_css('div[class="afisha-part-body"]').inner_text
      words.each do |word|
	if item.include? word
	  result << local_url
	  puts local_url
	  break
	end
      end
    end
  end
end
