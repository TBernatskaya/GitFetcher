# GitFetcher

This app fetches list of GitHub repositories by username (for ex. TBernatskaya).

**What's done:**
 - search for repositories by username
 - display details view for each repository by tap on table view cell
 - on detail view you can star/unstar* repository - result will be updated on both detail view and search results
 - error handling
 - unit tests
 
**TODO:**
 - save private key to Keychain
 - improve detail view UI
 - process some "heavy" operations in dispatch queue
 - UI tests
 
NOTE: to be able star/unstar repository you need to be authenticated GitHub user. To do that, copy-paste your private key to ApiService.swift file here: 
```swift
fileprivate let headers = ["Authorization": "Bearer \("xxx")"]
```

 
