require 'spec_helper'
require 'pry'

feature "User creats meetup" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "goes to show page" do
    visit '/'
    sign_in_as user

    click_link 'Create Meetup'

    fill_in "Name", with: "Funtime"
    fill_in "Description", with: "Iz very good"
    fill_in "Location", with: "Mars"

    click_button "Submit"

    expect(page).to have_content "Funtime"
    expect(page).to have_content "Iz very good"
    expect(page).to have_content "Mars"
    expect(page).to have_content "Event created!"
  end
end
