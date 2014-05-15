require 'kconv'
class IrController < ApplicationController

  force_ssl only: [:send_message,:contact]
  before_filter :force_plain,except: [:send_message,:contact]

  before_action :set_ir_message, only: [:contact,:send_message]

  #ログインを必要としない
  skip_before_filter :login_required

#  anot :index , parent: 'top#index',title:'株主・投資家の皆様へ'
#  def index
#  end
#
#  anot :highlight , parent: 'ir#index',title:'財務ハイライト'
#  def highlight
#  end
#
#  anot :infomation , parent: 'ir#index',title:'財務情報'
#  def infomation
#    @fdata = FINANCE_DATA
#    @dz = [16,17,18,19,20]
#  end
#
#  anot :business , parent: 'ir#index',title:'事業の概要'
#  def business
#  end
#  anot :announce , parent: 'ir#index',title:'電子公告'
#  def announce
#  end
#  anot :library , parent: 'ir#index',title:'IRカレンダー/ライブラリ'
  def library
    params["template"] = "press" if not params["template"]
    @body = transrate_irlib
    render 'contents/c_ir/library', :layout => nil
  end

#  anot :past_library ,parent: 'ir#library', title: 'IRカレンダー/ライブラリ',pattern: 'ir/library/:year(.:format)'
  def past_library
    params["template"] = "press1"
    @body = transrate_irlib
    render 'contents/c_ir/library', :layout => nil
  end
#
#  anot :stock , parent: 'ir#index',title:'株式情報'
#
#  anot :market , parent: 'ir#index',title:'株価情報'
#
#  anot :contact , parent: 'ir#index',title:'IRお問い合わせ'

  def contact
    render 'contents/c_ir/contact', :layout => nil
  end



  def send_message
    @ir_message = IrMessage.new(ir_message_params)
    if @ir_message.save

        #OPTIMIZE:メール送信はsidekiqに移行させるがとりあえず同期処理
        #まだ送られていない案件をすべて送信する
        IrMessage.not_sent.each do |i|
          i.report unless i.reported?
        end
        redirect_to url_for(action: :contact),notice: "担当宛に頂いたメッセージをお送りしました。ご連絡まことにありがとうございました。"
    else
        render 'contents/c_ir/contact',notice: "エラーが発生いたしました。大変申し訳ありませんが、時間を置いて再度お試しください。", :layout => nil
    end
  end

#  anot :disclaimer , parent: 'ir#index',title:'免責事項'
#  def disclaimer
#  end


  private
  def set_ir_message
    @ir_message = if params[:id].present? then
      IrMessage.find(params[:id])
    else
      IrMessage.new
    end
  end

  def ir_message_params
    params.require(:ir_message).permit(
        :name,
        :name_f,
        :company_name,
        :company_name_f,
        :mail_addr,
        :address,
        :message,
        :phone
    )
  end

  def transrate_irlib
    params["code"] = 3399 if not params["code"]
    params["ln"] = "ja" if not params["ln"]
    # params["year"] = 2009 if not params["year"]
    params["day"] = 365 if (not params["day"]) && (not params["year"])
    url = "http://v3.eir-parts.net/EIR/Eir.aspx?code=#{params['code']}&" +
    "template=#{params['template']}&" +
    "day=#{params['day']}&" +
    "ln=#{params['ln']}&" +
    "year=#{params['year']}"

    obj = Rails.cache.read(url)
    puts "--------------- cache hit! --------" unless obj.blank?
    return obj unless obj.blank?

    txt = RestClient.get(url)
    txt.force_encoding('cp932')
    @doc = Nokogiri::HTML.parse(
        txt.encode('utf-8')
    )
    #BODY要素を取得
    body = ((@doc/:body)[0]/:table)[0]

    #1 [img]を処理
    (body/:img).each do |img|
      h2 = "<h2 class='lib'>#{img['alt']}</h2>"
      #h2 = Kconv.kconv(h2,Kconv::SJIS,Kconv::UTF8)
      img.swap(h2) if img["alt"] != "Get Adobe Reader" and !img["alt"].nil?
      img["src"] = "/assets/site/get_reader.gif" if img["alt"] == "Get Adobe Reader"
      img.remove_attribute("width")
      img.remove_attribute("height")
      img.swap("") if img["alt"].nil?
    end

    #2 [table]のwidthを削除
    cnt = 0
    (body/:table).each do |tbl|

      #一個目は親なので、2個目を削除
      tbl.swap("") if tbl.search("tbody").size != 0 && cnt == 1
      tbl.remove_attribute("width")
      tbl.remove_attribute("border")
      tbl.remove_attribute("cellpadding")
      tbl.remove_attribute("cellspacing")
      cnt += 1
    end
    body.search("td").each do |td|
      #表示のカスタマイズ
      td.remove_attribute("background")
      td.remove_attribute("bgcolor")
      td.set_attribute("class", "title") if (td["valign"] == "bottom" || (td["valign"] == "top" && td["class"] == "txt10"))
      td.set_attribute("class", "date") if (td["width"] == "20%")
      td.set_attribute("class", "contents") if (td["width"] == "80%")
      td.set_attribute("class", "txt10") if (td["style"] == "width:10%")
      td.set_attribute("width", "100%") if (td["width"] == "750")
      td.remove_attribute("class") if td.search("form").size != 0
      td.remove_attribute("class") if td["align"]=="right" && td["class"]=="txt10"

      #過去ページの戻りリンク（上）の削除
      td.swap("") if td["align"] == "right" && td["width"] == "29%"
      td.set_attribute("width","100%") if td["align"] == "left" && td["width"] == "71%" && td["height"] == "25" && td["valign"] == "middle"
    end
    body.search("th").each do |td|
      td.remove_attribute("background")
      td.remove_attribute("bgcolor")
    end
    #2 [select]のURLを変換
    now_year = Time.now.year
    (body/:option).each do |opt|
       opt["value"] = "/c_ir/library/#{now_year}.html"
       now_year = now_year -1
    end
    Rails.cache.write(url,body.to_s)
    puts "--------------- cache store! --------"
    body
  end

    FINANCE_DATA = {

      12 =>{
        :a01 => 4094450,
        :a02 => 217690,
        :a03 => 105413,
        :a04 => 694018,
        :a05 => 2338894,
        :a06 => 95991.52,
        :a07 => 14763.72,
        :a08 => nil,
        :a09 => 29.7,
        :a10 => 16.6,
        :a11 => nil,
        :a12 => 363043,
        :a13 => -561894,
        :a14 => 117099,
        :a15 => 182953,
        :a16 => 240,
        :a16d=> 222,
        :b01 => 3998817,
        :b02 => 197538,
        :b03 => 93024,
        :b04 => 172647,
        :b05 => 7230,
        :b06 => 694018,
        :b07 => 2338894,
        :b08 => 95991.52,
        :b09 => nil,
        :b09d=> nil,
        :b10 => 13029.2,
        :b11 => nil,
        :b12 => 29.7,
        :b13 => 15.1,
        :b14 => nil,
        :b15 => nil,
        :b16 => nil,
        :b17 => nil,
        :b18 => nil,
        :b19 => nil,
        :b20 => 240,
        :b20d=> 222
      },
      13=>{
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 5100858,
        :b02 => 271226,
        :b03 => 132140,
        :b04 => 172647,
        :b05 => 7230,
        :b06 => 829970,
        :b07 => 3058704,
        :b08 => 114795.39,
        :b09 => nil,
        :b09d=> nil,
        :b10 => 18276.71,
        :b11 => nil,
        :b12 => 27.1,
        :b13 => 17.3,
        :b14 => nil,
        :b15 => nil,
        :b16 => 332298,
        :b17 => -826757,
        :b18 => 517312,
        :b19 => 205807,
        :b20 => 288,
        :b20d=> 313
      },
      14=> {
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 5959462,
        :b02 => 174968,
        :b03 => 85630,
        :b04 => 291647,
        :b05 => 8230,
        :b06 => 1211596,
        :b07 => 3757466,
        :b08 => 147217.10,
        :b09 => 5000,
        :b09d=> nil,
        :b10 => 10456.76,
        :b11 => nil,
        :b12 => 32.2,
        :b13 => 8.4,
        :b14 => 22.1,
        :b15 => 47.8,
        :b16 => 304772,
        :b17 => -892626,
        :b18 => 573487,
        :b19 => 191440,
        :b20 => 310,
        :b20d=> 374
      },
      15=>{
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 6444178,
        :b02 => 92168,
        :b03 => 20270,
        :b04 => 291647,
        :b05 => 8230,
        :b06 => 1118299,
        :b07 => 3717489,
        :b08 => 144386.35,
        :b09 => 5000,
        :b09d=> nil,
        :b10 => 2462.98,
        :b11 => nil,
        :b12 => 32.0,
        :b13 => 1.7,
        :b14 => 37.8,
        :b15 => 203.0,
        :b16 => 338775,
        :b17 => -226107,
        :b18 => -58256,
        :b19 => 245851,
        :b20 => 303,
        :b20d=> 361
      },
      16=>{
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 7033515,
        :b02 => 243433,
        :b03 => 118307,
        :b04 => 291647,
        :b05 => 8230,
        :b06 => 1261918,
        :b07 => 4057604,
        :b08 => 153331.57,
        :b09 => 5000,
        :b09d=> nil,
        :b10 => 14375.11,
        :b11 => nil,
        :b12 => 31.1,
        :b13 => 9.4,
        :b14 => 6.5,
        :b15 => 34.8,
        :b16 => 589560,
        :b17 => -457536,
        :b18 => 54134,
        :b19 => 432009,
        :b20 => 260,
        :b20d=> 505
      },

      17=>{
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 7223968,
        :b02 => 393275,
        :b03 => 207064,
        :b04 => 291647,
        :b05 => 8230,
        :b06 => 1430465,
        :b07 => 4556427,
        :b08 => 173509.71,
        :b09 => 5000,
        :b09d=> nil,
        :b10 => 25159.72,
        :b11 => 25098.73,
        :b12 => 31.3,
        :b13 => 14.5,
        :b14 => 5.1,
        :b15 => 19.9,
        :b16 => 514031,
        :b17 => -696615,
        :b18 => 159937,
        :b19 => 409363,
        :b20 => 245,
        :b20d=> 652
      },

      18=>{
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 7952626,
        :b02 => 290018,
        :b03 => 115560,
        :b04 => 291647,
        :b05 => 8230,
        :b06 => 1940467,
        :b07 => 5095367,
        :b08 => 182949.02,
        :b09 => 5000,
        :b09d=> nil,
        :b10 => 14172.27,
        :b11 => 14108.25,
        :b12 => 29.1,
        :b13 => 7.8,
        :b14 => 8.3,
        :b15 => 35.3,
        :b16 => 431171,
        :b17 => -1047573,
        :b18 => 371781,
        :b19 => 164742,
        :b20 => 252,
        :b20d=> 820
      },

      19=>{
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 8712310,
        :b02 => 57895,
        :b03 => -178112,
        :b04 => 291647,
        :b05 => 8230,
        :b06 => 1272705,
        :b07 => 5496216,
        :b08 => 1558.95,
        :b09 => 5000,
        :b09d=> nil,
        :b10 => -219.54,
        :b11 => nil,
        :b12 => 23.0,
        :b13 => nil,
        :b14 => nil,
        :b15 => nil,
        :b16 => 538203,
        :b17 => -839986,
        :b18 => 387820,
        :b19 => 250780,
        :b20 => 282,
        :b20d=> 887
      },

      20 => {
        :a01 => nil,
        :a02 => nil,
        :a03 => nil,
        :a04 => nil,
        :a05 => nil,
        :a06 => nil,
        :a07 => nil,
        :a08 => nil,
        :a09 => nil,
        :a10 => nil,
        :a11 => nil,
        :a12 => nil,
        :a13 => nil,
        :a14 => nil,
        :a15 => nil,
        :a16 => nil,
        :a16d=> nil,
        :b01 => 8909344,
        :b02 => 176058,
        :b03 => 3186,
        :b04 => 291647,
        :b05 => 8230,
        :b06 => 1234962,
        :b07 => 5119530,
        :b08 => 1513.03,
        :b09 => 2000,
        :b09d=> nil,
        :b10 => 3.93,
        :b11 => nil,
        :b12 => 24.0,
        :b13 => 0.3,
        :b14 => 211.7,
        :b15 => 509.1,
        :b16 => 620140,
        :b17 => -156090,
        :b18 => -402269,
        :b19 => 312560,
        :b20 => 260,
        :b20d=> 860
      }
    }.freeze

end
