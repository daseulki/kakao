require 'parse'

class KakaoController < ApplicationController
  def keyboard
    home_keyboard = {
      type: "text"
    }
    render json: home_keyboard
    #홈키보드 = 맨첨에 뜨는 키보드화면
  end

  def message
    image=false
    curr =false

    user_message = params[:content]

    if user_message == '뭐먹지'
      menus = ["떡볶이","햄버거","라면","중국집","피자","치킨","파스타","굶어","볶음밥","김치찌개","초밥","쌀국수"]
      bot_message = menus.sample

    elsif user_message == '로또'
      lotto = (1..45).to_a.sample(6).to_s
      bot_message = lotto

    elsif user_message == '환율'
      parser = Parse::Daum.new
      now_currency = parser.currency
      bot_message = now_currency

    elsif user_message == "명언"

      url = 'https://search.naver.com/search.naver?query=%EB%AA%85%EC%96%B8'
      saying_html = RestClient.get(url)
      doc = Nokogiri::HTML(saying_html)
      bot_message = doc.css('#main_pack > div.content_search.section > div > div.contents03_sub > div > div.cnt_box > ul:nth-child(1) > li > div:nth-child(2) > div > p.lngkr').text + "\n  -" + doc.css('#main_pack > div.content_search.section > div > div.contents03_sub > div > div.cnt_box > ul:nth-child(1) > li > div:nth-child(2) > dl > dt > a').text
      bot_message = "오늘의 명언\n" + doc.css('#main_pack > div.content_search.section > div > div.contents03_sub > div > div.cnt_box > ul:nth-child(1) > li > div:nth-child(2) > div > p.lngkr').text + "\n  -" + doc.css('#main_pack > div.content_search.section > div > div.contents03_sub > div > div.cnt_box > ul:nth-child(1) > li > div:nth-child(2) > dl > dt > a').text

    elsif user_message == "날씨"
      parser = Parse::Daum.new
      seoul_weather = parser.weather
      bot_message = seoul_weather

    elsif user_message == "고양이"
      image = true
      parser = Parse::Animal.new
      cat = parser.cat
      bot_message = cat[0]
      img_url = cat[1]

    elsif user_message == "영화"
      image = true
      parser = Parse::Movie.new
      one_movie = parser.naver
      bot_message = one_movie[0]
      img_url = one_movie[1]

    elsif user_message == "이게뭐야"
      bot_message = "뭐먹지, 환율, 영화, 명언, 로또, 날씨도 물어보고.. 고양이도 볼 수 있지 캬캬\n귀여운게 최고야!!!\n비밀인데.. 심심해 라고 하면 안심심하게 해줄거야"

    elsif user_message == "심심해"
      bot_message = ["아침에 총쏘면???\n 모닝 빵! 빵터졌찌?ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ","사과가 웃으면??\n풋사과!!!! 푸우우ㅜㅅ훟ㅅ훟","세상에서 가장 쉬운 숫자는???\n190,000!! 뭐냐면 쉽구만 쉬워 ㅎㅎ 웃기기 쉬워 ㅎㅎ", "깡통으로 만든 버스는?\n 캔버스 캬캬ㅑ컄ㅋ","얼음이 죽으면 뭐게~~~~ \n다이빙(꽁꽁)","용은 용인데 소리 못내는 용이 뭘까???\n 조용조용... ","세상에서 제일 뜨거운 과일은?\n천도 복숭아야 까르르르 1000도나 된다구 까르르르르"].sample

    elsif user_message == "안녕"

      bot_message = ["하이루", "안뇽","안녕","방가방가","'이게뭐야'를 쳐봐!"].sample

    else
      etc = ["히히","으으응","아니야","몰라몰라", "뭐 할지 모르겠으면 '이게뭐야'를 쳐봐","응 바보야"]
      bot_message = etc.sample

    end #if user_message 끝



    return_message = {
      message: {text: bot_message},
      keyboard: {type: "text"}
    }
    return_message_with_img = {
      message: {
        text: bot_message,
        photo: {
          url: img_url,
          width: 640,
          height: 480
        }
      },
      keyboard: {type: "text"}
    }


    if image == true
      render json: return_message_with_img

    else
      render json: return_message
    end #이미지 유무 끝


  end #메세지 액션 끝
end
