require 'rspec'
require './UrlFormValidator'

describe 'UrlFormValidaotr' do
  VALID_URL = 'https://domain.pl'.freeze
  INVALID_URL = 'invalid'.freeze
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
