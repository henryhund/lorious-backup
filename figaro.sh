#! /bin/sh

rake figaro:heroku[lorious-mvp]
rake figaro:heroku[lorious-mvp-dev]

heroku restart --app lorious-mvp
heroku restart --app lorious-mvp-dev
# rake figaro:heroku[alpha-everylastmorsel]
# rake figaro:heroku[beta-everylastmorsel]