fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios renew_provision_profile

```sh
[bundle exec] fastlane ios renew_provision_profile
```

Force renew provision profile

### ios firebase_login

```sh
[bundle exec] fastlane ios firebase_login
```

Login into firbase app distribution

### ios distribute_qa_build

```sh
[bundle exec] fastlane ios distribute_qa_build
```

Build and upload for internal testing

### ios firebase_distribute

```sh
[bundle exec] fastlane ios firebase_distribute
```

Firebase distribution

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
