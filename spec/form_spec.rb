require 'rspec'
require './UrlShortenForm'

describe 'UrlShortenForm' do
  VALID_URL = 'https://domain.pl'.freeze
  INVALID_URL = 'invalid'.freeze
  it 'exist' do
    service = UrlShortenForm.new(VALID_URL, {})
    expect(service).to be_truthy
  end

  it 'saves do database on save' do
    db = {}
    form = UrlShortenForm.new(VALID_URL,db)
    form.save
    expect(db[form.short]).to be form.url_name
  end

  it 'is invalid for invalid url' do
    db = {}
    form = UrlShortenForm.new(INVALID_URL, db)
    form.save
    expect(form.valid?).to be false
  end
end
