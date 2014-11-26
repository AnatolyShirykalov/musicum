class ClassicOnline
  def doc_at_utf(url)
    begin
      html = open((base_url+url).to_s).read
      doc = Nokogiri::HTML(html.gsub('charset=windows-1251"', 'charset=utf-8"'))
    rescue => e
      case e
      when Open::HTTPError
        puts 'OpenURI::HTTPError'
	nil
      else
	raise e
      end
    end
  end
  def base_url
    URI.parse("http://classic-online.ru/")
  end
    
  def parse_bests
    url = '/stat/?type=top_persons&person_type=composer'
    doc = doc_at_utf(url)
    els = doc.css('td[class="first"]')
    els.each do |el|
      url = (el.css('a')>('img')).attr('src')
      f = open((base_url + url).to_s)
      url = el.css('a').attr('href')
      doc = doc_at_utf(url)
      h1 = doc.at_css('div[id="vse"]')>('div[class="cnt"]')>('div[class="cat"]')>('div[class="data-case"]')>('div[class="data"]')>('h1')
      name = (h1.inner_text.split("\n")[0]).gsub(/ \z/,'')
      composer = Composer.any_of({co_url: url}).first
      composer = Composer.create(name: name,co_url: url) if composer.nil?
      composer.avatar = f if composer.avatar_file_name.nil?
      composer.save
      pieces = doc.css('tr[class="result"]')
      pieces.each do |piece|
        name = (piece.css('td[class="prdName"]')>('a')).inner_text
	opus = (piece.css('td[class="prdOpus"]')>('a')).inner_text
	co_url = (piece.css('td[class="prdName"]')>('a')).attr('href')
	pi = Piece.any_of({co_url: co_url}).first
	composer.pieces.create(name: name, opus: opus,
				 co_url: co_url) if pi.nil?
      end
      composer.save
      puts name
    end
  end
end
