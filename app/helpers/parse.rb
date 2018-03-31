module Parse
  class Movie
    def naver
      url = "http://movie.naver.com/movie/running/current.nhn"
      url = URI.encode(url)
      movie_html = RestClient.get(url)
      doc = Nokogiri::HTML(movie_html)

      movie_list = Array.new
      movies = Hash.new

      doc.css('ul.lst_detail_t1 li').each do |movie|
        movie_title = movie.css('dt a').text
        movie_list << movie_title

        movies[movie_title] = {
          rating: movie.css('dl.info_star span.num').text,
          thumb: movie.css('div.thumb img').attribute('src').to_s
        }
        #:신과함께 => {:star => "8"} 이런식으로 생김
      end #each do 끝

      sample_movie = movie_list.sample
      bot_message = sample_movie +  ": " + movies[sample_movie][:rating] +"점"
      img_url =  movies[sample_movie][:thumb]

      return [bot_message,img_url]
    end
  end
  class Daum
    def currency
      url = "http://finance.daum.net/exchange/exchangeMain.daum"
      url = URI.encode(url)
      curr_html = RestClient.get(url)
      doc = Nokogiri::HTML(curr_html)
      bot_message = "매매기준율이야\n1달러(USD) 당 " + doc.css('#exInfoList > li:nth-child(1) > div > dl > dd.exPrice').text + "원\n1유로(EUR) 당 " + doc.css('#exInfoList > li:nth-child(4) > div > dl > dd.exPrice').text + "원\n1위안(CNY) 당 " + doc.css('#exInfoList > li:nth-child(3) > div > dl > dd.exPrice').text + "원\n1엔(JPY) 당 " + doc.css('#exInfoList > li:nth-child(2) > div > dl > dd.exPrice').text + "원!"

      bot_message
    end

    def weather
      url = "https://search.daum.net/search?w=tot&DA=Z8T&q=%EC%84%9C%EC%9A%B8%20%EC%98%A4%EB%8A%98%20%EB%82%A0%EC%94%A8&rtmaxcoll=Z8T"
      weather_html = RestClient.get(url)
      doc = Nokogiri::HTML(weather_html)
      bot_message = doc.css('#weatherColl > div.coll_cont > div > div.wrap_region.today > div.cont_weather > div.cont_today > div.info_temp > div > span > span.desc_temp > span').text + "\n" + doc.css('#weatherColl > div.coll_cont > div > div.wrap_region.today > div.cont_weather > div.cont_today > div.info_temp > div > span > span.desc_temp > strong').text

       bot_message

    end
  end


  class Animal
    def cat
      url ="http://thecatapi.com/api/images/get?format=xml&type=jpg"
      #cat 갖고오기
      cat_xml = RestClient.get(url)

      #컴퓨터가 보기쉽게 고쳐주기
      doc = Nokogiri::XML(cat_xml)

      #일케하면 태그까지 다불러와짐 그니까 .text 붙여서 텍스트만 갖고온다
      img_url = doc.xpath("//url").text
      bot_message = "나만 고양이 없어.."

      #사실 리턴 안써도 맨 아래꺼 자동 리턴, 배열을 보내주자
      return [bot_message, img_url]
    end
  end
end
