require 'rspec'
require 'capybara/rspec'
require './App'

Capybara.app = App

describe "the index page", type: :feature do

    it "shows form" do
      visit '/'
      expect(page).to have_xpath('//form')
    end

    it "shows error on bad form" do
        visit '/'
        fill_in("url_name", with: "bad url")
        find('button[type="submit"]').click

        expect(page).to have_content("It's not a valid URL")
    end

    it "shows url on good form" do
        valid_url = "http://valid.pl"
        visit '/'
        fill_in("url_name", with: valid_url)
        find('button[type="submit"]').click

        expect(page).to have_xpath('//a')
    end
end
