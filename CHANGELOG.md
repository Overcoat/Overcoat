# Overcoat Changelog

## 3.0

* Support Mantle 2.0. [Pull Request #87](https://github.com/Overcoat/Overcoat/pull/87) (@sodastsai)
* Refine project structure including reorganizing folders, use subspecs, and share common codes
  [Pull Request #91](https://github.com/Overcoat/Overcoat/pull/91) (commits) (@sodastsai, @ryanmaxwell)
* Refine the dependency to PromiseKit. [Pull Request #85](https://github.com/Overcoat/Overcoat/pull/85) (@mxcl)
* Fix Core Data threading issue when saving objects [Pull Request #76](https://github.com/Overcoat/Overcoat/pull/76) (@nunofgs)

### Summary of 3.0 release

* Support Mantle 2.0
* Use podspec to re-organize features. (Take `CoreData` and `Social` support apart from `Core`)
* Separate `CoreData` classes (for example, `OVCHTTPSessionManager` -> `OVCManagedHTTPSessionManager`)
