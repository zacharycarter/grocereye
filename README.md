# grocereye

### Using computer vision to detect objects in images

## Notes

1. I wasn't able to fully complete any of the asks in the assignment. I worked on this for two days, as I had another assignment to complete prior to this one, but unfortunately that wasn't enough time given my inexperience with Haskell.

2. This is the first time I've ever used the Haskell programming language.

3. I managed to get the following working:
    - User can upload an image to the `/upload` endpoint as a Multipart Form request.
    - After the image is uploaded, the Imagga API is called.
    - The response is unmarshalled into a Haskell type.
    - The Haskell type is printed to the console.

4. What ended up eating up a lot of my time was the following:
    - Figuring out how to make use of the uploaded file.
        - I followed the example in the `scotty` repository, but it was pretty barebones.
    - Understanding how to unmarshall the JSON response from Imagga API into a Haskell type.
    - What finally did me in was conversion from the Haskell Type into a record type that I could insert into the database.
    - Trying to get various libraries and dependencies working, and constantly running into errors related to version conflicts and build failures.
    - Haskell

5. I didn't even want to approach writing any unit tests - I used [Hurl](https://hurl.dev/) to test my work. There's a `test.hurl` file in the `test` folder which can be run with `hurl test/test.hurl` assuming Hurl is installed. Installation instructions can be found [here](https://hurl.dev/docs/installation.html). There's also an image file  in the `test` directory named `groceries.jpg` which is used in the test.

6. Even though I didn't manage to complete the assignment, I learned a lot and had a lot of fun attempting it. It might have been a better decision to go with a language I am more comfortable in, but I wanted to demonstraate my ability to self-start with new technologies and programming languages.

6. Obviously I didn't really get to a point where I could working making the app production ready. There are a number of things I would do, such as:
    - Read the database connection information from environment variables and find a solution for migrations.
        - I actually had the env var portion of this working, but ran into trouble getting `postgresql-simple-migration` working, so I nuked it.
    - Add a Dockerfile and setup Docker Compose so the user doesn't have to install PostgreSQL on their machine.
    - Author unit tests.
    - Validate incoming requests to the API.
    - Documentation.

7. Regarding some of my plans for completing the remaining tasks:
    - I was going to store the tags in a `jsonb` column in the image table.
    - I didn't want to mess with anything that approached an ORM given my inexperience with the language, which is why I chose to go with  `postgresql-simple`. This would have allowed me to write plain old SQL for querying the tags in the table for ones provided by consumers of the API.


Thanks so much for affording me the opportunity to participate in this challenge! I very much enjoyed it and will definitely be diving into more Haskell in the future!