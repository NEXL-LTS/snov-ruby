* allow token to be stored and reused
* add OutOfCreditsError
* remove "\u0000" from response

## [0.5.0]
* support for https://snov.io/api#EmailFinder (GetEmailsFromName)

## [0.4.1]
* allow forward slash for test response files while using fake client

## [0.4.0]
* search prospect emails with /v1/get-emails-from-url

## [0.3.2]
* increase snov timeout to 90 seconds
## [0.3.1]
* fix fake result for /v1/prospect-list

## [0.3.0]
* add Faraday response into exception
* fake client to only return success result for selected queries

## [0.2.4]
* Fix DomainSearch to_a

## [0.2.3]
* Fix DomainSearch doing post instead of get
## [0.2.2]
* DomainSearch Response class

## [0.2.1]
* DomainSearch fake example data

## [0.2.0]
* DomainSearch

## [0.1.1]

### Fixed
* GetProspectsByEmail & GetProspectList to always return arrays when expecting one

## [0.1.0]
* GetUserLists
* GetProspectList
* GetAllProspectsFromList
* GetProspectsByEmail
