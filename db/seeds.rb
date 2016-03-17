User.create(
  provider: "github",
  uid: "1",
  username: "jarlax1",
  email: "jarlax1@launchacademy.com",
  avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
)

Meetup.create(
  meetup_name: "DogWalkerz",
  description: "For cat owners ONLY",
  location: "My backyard"
)

Event.create(
  user_id: 1,
  meetup_id: 1,
  creator: true
)
