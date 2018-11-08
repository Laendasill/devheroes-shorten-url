require 'rspec'
require './url_form_validator'

describe 'UrlFormValidaotr' do
  let(:valid_url) { 'https://domain.pl'.freeze }
  let(:invalid_url) { 'invalid'.freeze }
  it 'have no errors on valid url' do
    validator = UrlFormValidaotr.new(valid_url)
    validator.validate
    expect(validator.errors?).to be false
  end

  it 'have errors on invlaid error' do
    validator = UrlFormValidaotr.new(invalid_url)
    validator.validate
    expect(validator.errors?).to be true
  end
  
  it 'have error message for blank url' do
    validator = UrlFormValidaotr.new('')
    validator.validate
    expect(validator.errors[0]).to include "url can't be blank"
  end

  it 'have error message for invalid url' do
    validator = UrlFormValidaotr.new(invalid_url)
    validator.validate
    expect(validator.errors[0]).to include "It's not a valid URL"
  end
end
