require 'rspec'
require './UrlShortenForm'
require './Model'

describe 'UrlShortenForm' do
  let(:valid_url) { 'https://domain.pl'.freeze }
  let(:invalid_url) { 'invalid'.freeze }
  
  it 'exist' do
    service = UrlShortenForm.new(valid_url, {})
    expect(service).to be_truthy
  end

  it 'saves do database on save' do
    db = Model.new
    form = UrlShortenForm.new(valid_url, db)
    form.save
    expect(db.get(form.short)).to be form.url_name
  end

  it 'is invalid for invalid url' do
    db = Model.new
    form = UrlShortenForm.new(invalid_url, db)
    form.save
    expect(form.valid?).to be false
  end
end
