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

describe 'UrlFormValidaotr' do
  it 'have no errors on valid url' do
    validator = UrlFormValidaotr.new(VALID_URL)
    validator.validate
    expect(validator.errors?).to be false
  end

  it 'have errors on invlaid error' do
    validator = UrlFormValidaotr.new(INVALID_URL)
    validator.validate
    expect(validator.errors?).to be true
  end
  
  it 'have error message for blank url' do
    validator = UrlFormValidaotr.new('')
    validator.validate
    expect(validator.errors[0]).to include "url can't be blank"
  end

  it 'have error message for invalid url' do
    validator = UrlFormValidaotr.new(INVALID_URL)
    validator.validate
    expect(validator.errors[0]).to include "It's not a valid URL"
  end
end
