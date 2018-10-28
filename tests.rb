require 'rspec'
require 'capybara/rspec'
require './App'

Capybara.app = App

describe 'the index page', type: :feature do
  it 'shows form' do
    visit '/'
    expect(page).to have_xpath('//form')
  end

  it 'shows error on bad form' do
    visit '/'
    fill_in('url_name', with: 'bad url')
    find('button[type="submit"]').click

    expect(page).to have_content("It's not a valid URL")
  end

  it 'shows error on empty form' do
    visit '/'
    fill_in('url_name', with: '')
    find('button[type="submit"]').click

    expect(page).to have_content("Please enter valid url")
  end

  it 'shows url on good form' do
    valid_url = 'http://valid.pl'
    visit '/'
    fill_in('url_name', with: valid_url)
    find('button[type="submit"]').click

    expect(page).to have_xpath('//a')
  end

  it 'redirects on existing url' do
    valid_url = 'http://valid.pl'
    visit '/'
    fill_in('url_name', with: valid_url)
    find('button[type="submit"]').click

    find('a').click
    expect(page.current_url).to include valid_url
  end
end
