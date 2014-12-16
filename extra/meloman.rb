class Meloman
  def base_url
    URI.parse('http://meloman.ru')
  end
  def doc_at_utf(url)
    begin
    html = open((base_url+url).to_s).read
    doc = Nokogiri::HTML(html)
    rescue => e
      if (e.class ==  OpenURI::HTTPError) or (e.class== SocketError)
        puts e.message
        return e
      else
        raise e
      end
    end
  end
  def parse_dates(conditions)
    return nil if conditions=={} or conditions[:since].nil? or conditions[:til].nil?
    res = []
    (conditions[:since]..conditions[:til]).each do |date|
      res = res | parse_month(date,conditions) if date.day==1 or date==conditions[:since]
    end
    res
  end
  def parse_month(date,conditions={})
    doc = doc_at_utf((base_url+"/calendar/?month=#{date.month}&=#{date.year}").to_s)
    res = []
    if doc.class!=Nokogiri::HTML::Document
      Hall.all.map do |h|
	if h[:url]==base_url.to_s
          h.concerts.map do |c|
	    res = res | [c] if c.valid(conditions)
	  end
	end
      end
      return res
    end
    items = doc.css('li[class="hall-entry pseudo-link"]')
    items.each do |item|
      hall_name = (item>('div[class="hall-entry-head"]')>('h6')).inner_text.gsub(/(\n| {2,})/,'')
      hall = get_hall(hall_name)
      url = item.attr('data-link')
      concert = parse_event(url,hall,conditions)
      res = res | [concert] if concert
    end
    res
  end
  def parse_event(url,hall,conditions={})
    concert = Concert.any_of(url: (base_url+url).to_s).first
    return concert if concert and concert.valid(conditions)
    return nil if concert and not concert.valid(conditions)
    return nil if conditions[:noweb]
    doc = doc_at_utf(url)
    date = get_date((doc.css('div[style="text-align: center;"]')>('p[class="text size18"]')).first.inner_text.gsub(/(\n| {2,})/,''))
    texts = doc.css('div[class="right-half programme"]')>('div[class="small-row align-left"]')
    concert = hall.concerts.new(url: (base_url+url).to_s, date: date)
    concert[:desc] = texts[0].inner_html.gsub(/(href="\/)([^"]+)"/,"\\1#{base_url.to_s}/\\2\"") if texts[0] and not texts[0].inner_text.include?('В программе:')
    concert[:prog] = texts[1].inner_html.gsub(/(href="\/)([^"]+)"/,"\\1#{base_url.to_s}/\\2\"") if texts[1] and texts[1].inner_text.include?('В программе:')
    return concert if concert.save and concert.valid
    return nil
  end
  def get_date(text)
    d_cs = (text.split(',')[0]).split(' ')
    Date.new(d_cs[2].to_i,get_month(d_cs[1]),d_cs[0].to_i)
  end
  def get_month(text)
    kvs = { "января"   => 1, "февраля" =>  2, "марта"  =>  3, "апреля"   => 4,
            "мая"      => 5, "июня"    =>  6, "июля"   =>  7, "августа"  => 8,
            "сетнября" => 9, "октября" => 10, "ноября" => 11, "декабря" => 12}
    kvs[text]
  end

  def get_hall(name)
    hall = Hall.any_of(name: name).first
    return hall if hall
    hall = Hall.create(name: name, url: base_url)
  end
end
