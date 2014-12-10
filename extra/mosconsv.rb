class Mosconsv
  def base_url 
    URI.parse('http://mosconsv.ru')
  end
  def doc_at_utf(url)
    begin
      html = open((base_url+url).to_s).read
      doc = Nokogiri::HTML(html.gsub('charset=windows-1251"', 'charset=utf-8"'))
    rescue => e
      if (e.class ==  OpenURI::HTTPError) or (e.class== SocketError)
        puts e.message
        return e
      else
        raise e
      end
    end
  end
  def parse_date(date,conditions={})
   res = Concert.any_of(date: date).to_a
   if res != []
     items = res
     res = []
     items.each do |item|
       res = res | [item] if valid(item,conditions)
     end
   end
   url = "/ru/concert-date.aspx?sel_date=#{date.to_s}"
   doc = doc_at_utf(url)
   return res if doc.class != Nokogiri::HTML::Document
   items = doc.css('div[class="center-conc-hall-item dotted-link"]')>('div[class="center-conc-hall-event-item dotted-link"]')>('div[id="right"]')>('div')>('a')
   items.each do |item|
     cur = parse_event(item.attr('href'),conditions)
     res = res | [cur] if cur
   end
   res
  end
  def parse_event(url,conditions={})
    return nil if not url.to_s.include?("concert.aspx")    
    c_url = (base_url + url).to_s
    concert = Concert.any_of(url: c_url).first
    return concert if concert and concert[:desc] and concert[:prog] and valid(concert,conditions)
    doc = doc_at_utf(url)
    hall = get_hall(doc)
    return nil if (hall.nil? or invalid(doc,conditions))
    txt= doc.at_css('title').inner_text.gsub(/\A[^\\z]*Афиша +(\d+) +([а-яё]+) +(\d+)[^\z]+\z/,'\3-\2-\1').split('-')
    desc = doc.at_css('div[class="afisha-desc"]').inner_html
    prog = doc.at_css('div[class="afisha-part-body"]').inner_html
    concert.update!(desc: desc, prog: prog) if concert
    return concert if concert
    concert = hall.concerts.create(url: c_url, desc: desc, prog: prog,
		date: Date.new(txt[0].to_i,get_month(txt[1]),txt[2].to_i))
  end
  def get_hall (doc)
    s = (doc.at_css('div[class="afisha-hall dotted-link"]')>('span')>('a')).inner_text
    name = "#{"Большой" if s[0]=="Б"}#{"Малый" if s[0]=="М"}#{"Рахманиновский" if s[0]=="Р"} зал консерватории"
    hall = Hall.any_of(name: name).first
    hall = Hall.create(name: name, url: base_url) if hall.nil?
    hall
  end
  def get_month(text)
    kvs = { "января"   => 1, "февраля" =>  2, "марта"  =>  3, "апреля"   => 4,
	    "мая"      => 5, "июня"    =>  6, "июля"   =>  7, "августа"  => 8,
	    "сетнября" => 9, "октября" => 10, "ноября" => 11, "декабря" => 12}
    kvs[text]
  end
  def valid(event,conditions={})
    return false if event.nil?
    return true if conditions=={}
    list = conditions[:sufficient]
    return true if list.nil? or list.empty?
    return false if event[:desc].nil? and event[:prog].nil?
    list.each do |word|
      return true if (event[:desc] and event[:desc].match(word)) or (event[:prog] and event[:prog].match(word))
    end
    return false
  end
  def invalid(doc,conditions={})
    return false if conditions=={}
    inval = false
    list = conditions[:sufficient]
    return false if list.nil? or list.empty?
    desc = doc.at_css('div[class="afisha-desc"]').inner_text
    prof = doc.at_css('div[class="afisha-part-body"]').inner_text
    match = false
    list.each do |word|
      match = true if desc.match(word) or prof.match(word)
    end
    return false if match
    return true
  end
end
