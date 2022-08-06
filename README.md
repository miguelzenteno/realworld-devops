For this repository we are using 2 git subtrees:
- https://github.com/miguelzenteno/mint-realworld.git for the `frontend`
- https://github.com/miguelzenteno/realworld-dynamodb-lambda.git for the `backend`

Both repositories are forks of their respective original repositories, but we are adding the necessary changes to make the CI/CD work, so that includes the gitlab pipeline and the terraform code to make this repository work.