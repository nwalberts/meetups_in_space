require 'spec_helper'
require 'pry'

feature "User goes to show page" do
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

    meetup1 = Meetup.create(
      meetup_name: "Painting Pals" ,
      description: "This is a fun meetup for humans",
      location: "The Moon"
    )

    event = Event.create(
        user: user,
        meetup: meetup1,
        creator: true
      )

    visit '/'
    sign_in_as user
    binding.pry

    save_and_open_page

    click_link 'Painting Pals'
    expect(page).to have_content(meetup1.description)
    expect(page).to have_content(meetup1.location)
    expect(page).to have_content "jarlax1"
  end
end
