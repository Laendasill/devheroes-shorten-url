require "rspec"
require "./UrlShortenService"

describe "UrlShortenService" do

    it "exist" do
      service = UrlShortenService.new({})
      expect(service).to be_truthy
    end

    it "returns string with length of 8 on call" do
      str = UrlShortenService.call({})
      expect(str.length).to be 8
    end
end