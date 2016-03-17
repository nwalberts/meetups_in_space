require 'spec_helper'
require 'pry'

feature "User goes to index page" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "sees list of meetups" do

    meetup1 = Meetup.create(
      meetup_name: "Painting Pals" ,
      description: "This is a fun meetup for humans",
      location: "The Moon"
    )

    meetup2 = Meetup.create(
      meetup_name: "DogWalkerz",
      description: "For cat owners ONLY",
      location: "My backyard"
    )

    visit '/meetups'
    sign_in_as user

    expect(page).to have_content(meetup1.meetup_name)
    expect(page).to have_content(meetup2.meetup_name)
  end
end
