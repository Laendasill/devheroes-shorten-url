require 'rspec'
require './url_shorten_form'
require './Model'

describe 'UrlShortenForm' do
  let(:valid_url) { 'https://domain.pl'.freeze }
  let(:invalid_url) { 'invalid'.freeze }
  
  it 'exist' do
    service = UrlShortenForm.new(valid_url, {})
    expect(service).to be_truthy
  end

  it 'saves do database on save' do
    db = HashModel.new
    form = UrlShortenForm.new(valid_url, db)
    form.save
    #puts form.short
    puts db.get(form.short)
    expect(db.get(form.short)).to eq(valid_url)
  end

  it 'is invalid for invalid url' do
    db = HashModel.new
    form = UrlShortenForm.new(invalid_url, db)
    form.save
    expect(form.valid?).to be false
  end
end
