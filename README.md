# golang-ci
CircleCI orb for performing common CI tasks for a Go project

#### How to use this project
Please refer to [CircleCI registry](https://circleci.com/orbs/registry/orb/financial-times/golang-ci) for information how to use this orb.

#### How the CI steps for this orb work

There are two CircleCI workflows associated with this project. They have different behaviour depending on whether they are triggered by commit push or by creating specific git tag.
1. On push

When you are pushing a commit in any branch including master, the first setup workflow is going to: 
* Lint the orb's code.
* Pack the orb source code into single yaml file.
* Review if the orb source code complies to predefined list of best practices.
* Lint the orb shell scripts.
* Deploy it as `dev:alpha` and `dev:<SHA1>` version. These dev versions of the orb are not visible in the CircleCI registry but can be referred by other projects and can be tested.
* Trigger the next CircleCI workflow. The new workflow allows the just uploaded dev version of the orb to be used. There is no way to refer to the newly deployed dev version of the orb in the same pipeline that it's been deployed.

When you are pushing a commit, the second workflow is going to:
* Run integration tests for the orb using the just deployed dev version. The integration tests in our case are actually running the main orb's jobs and ensuring they succeed.

2. On tag

When you are creating a new tag from master branch (you can use the simple GitHub UI to create new release with associated git tag), the first workflow is going to:
* Lint the orb's code.
* Pack the orb source code into single yaml file.
* Review if the orb source code complies to predefined list of best practices.
* Lint the orb shell scripts.
* Deploy it as `dev:alpha` and `dev:<SHA1>` version. These dev versions of the orb are not visible in the CircleCI registry but can be referred by other projects and can be tested.
* Trigger the next CircleCI workflow. The new workflow allows the just uploaded dev version of the orb to be used. There is no way to refer to the newly deployed dev version of the orb in the same pipeline that it's been deployed.

When you are creating a git tag, the second workflow is going to:
* Run integration tests for the orb using the just deployed dev version. The integration tests in our cases are actually running the main orb's jobs and ensuring they succeed.
* Pack the orb source code into single yaml file.
* Deploy the packed orb to the CircleCI registry as the new official orb version.

In order to trigger the deploying to registry step, your git tag should match the [semantic versioning standard](https://semver.org/).

#### How to contribute to this project

In order to create a new version of this orb and release it to CircleCI registry you should perform the following steps:
- Checkout a new branch and make your changes there. 
- Make sure that all checks are passing for your branch and make PR
- You can test the orb at this point in another project referring to it as `financial-times/golang-ci@dev:alpha` or `financial-times/golang-ci@dev:<SHA1>`
- After the PR is approved by 2 reviewers, you can merge it to master
- Create a GitHub release with the appropriate tag following [semantic versioning standard](https://semver.org/).

#### Some resource on writing CircleCI orbs
[Orb Authoring](https://circleci.com/docs/orb-author/)

[Orbs Concepts](https://circleci.com/docs/orb-concepts/)

[Orbs Reusable Config Reference Guide](https://circleci.com/docs/reusing-config/)

[Orbs tools for CI/CD for the orbs themselves](https://circleci.com/developer/orbs/orb/circleci/orb-tools?version=11.6.1)

[Orbs best practices](https://circleci.com/docs/orbs-best-practices/)
