# golang-ci
CircleCI orb for performing common CI tasks for a Go project

#### How to use this project
Please refer to [CircleCI registry](https://circleci.com/orbs/registry/orb/financial-times/golang-ci) for information how to use this orb.

#### How the CI steps for this orb work

There are two CircleCI workflows associated with this project. They have different behaviour depending on whether they are triggered by commit push or by creating/pushing specific git tag.
1. On push

When you are pushing a commit in any branch including master, the first workflow is going to: 
* lint the orb's code
* pack it into single yaml file 
* deploy it as "dev:alpha" version. These dev versions of the orb are not visible in the CircleCI registry but can be referred by other projects and can be tested.
* trigger a new CircleCI pipeline. The new pipeline actually allows the just uploaded dev version of the orb to be used. There is no way to refer to the newly deployed dev version of the orb in the same pipeline that it's been deployed.

When you are pushing a commit, the second workflow is going to:
* run integration tests for the orb using the just deployed dev version. The integration tests in our cases are actually running the main orb's jobs and ensuring they succeed.

2. On tag

When you are creating a new tag from master branch (you can use the simple GitHub UI to create new release with associated git tag), the first workflow is going to:
* lint the orb's code
* packed it into single yaml file 
* deploy it as "dev:alpha" version
* trigger a new CircleCI pipeline
* deploy new version of the orb in the CircleCI registry

In order to trigger the first workflow, your git tag should match the following regular expression `(major|minor|patch)-release-v\d+\.\d+\.\d+`. So if you want your release to upload new patch version of the orb, use tag patch-release-v1.0.1. Unfortunately the numbers in the release are ignored by CircleCI. It only takes into consideration if you tag is `major`, `minor` or `patch` and depending on that it just bumps the current version of the orb in the CircleCI registry. So if your release is `patch-relases-v1.1.12` and the current version of the orb in the registry is `v1.1.0`, you will actually release `v1.1.1` in the registry.

If you are creating a tag from branch different than master, the last step that is deploying the new version to the CircleCI registry will fail.

The second workflow is not triggered at all in cases where the first workflow is triggered by git tag. If you find a way to do so, please contribute.

#### How to contribute to this project

In order to create a new version of this orb and release it to CircleCI registry you should perform the following steps:
- Checkout a new branch and make your changes there. 
- Make sure that all checks are passing for your branch and make PR
- You can test the orb at this point in another project referring to it as `financial-times/golang-ci@dev:alpha`
- After the PR is approved by 3 reviewers, you can merge it to master
- Create a GitHub release with the appropriate tag (described in the previous section)

#### Some resource on writing CircleCI orbs
[Orb Authoring](https://circleci.com/docs/2.0/orb-author/)

[Orbs Concepts](https://circleci.com/docs/2.0/using-orbs/)

[Orbs Reference Guide](https://circleci.com/docs/2.0/reusing-config/)

[Orbs tools - writing CI/CD for the orbs themselves](https://circleci.com/orbs/registry/orb/circleci/orb-tools?version=9.0.0)

[Orbs best practices](https://circleci.com/docs/2.0/orbs-best-practices/)
