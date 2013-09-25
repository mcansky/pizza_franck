require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'json'

helpers do
  def status(id)
    url = "http://www.dominos.co.uk/checkout/pizzaTrackeriFrame.aspx?id=#{id}"
    uri = URI.parse url
    blob = uri.open.read
    doc = Nokogiri::HTML.parse blob
    arr = doc.search('.step-wrap').collect do |s|
      s['class'].split(' ').last
    end
    current_step = arr.select { |s| s.match /select/ }.first
    if current_step
      case current_step
      when /step1/
        "placed"
      when /step2/
        "preparation"
      when /step3/
        "bake"
      when /step4/
        "quality control"
      when /step5/
        "delivery"
      end
    else
      "delivered"
    end
  end
end

get '/:order_id' do
  {id: params[:order_id], status: status(params[:order_id])}.to_json
end
