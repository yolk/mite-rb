## mite-rb Changelog

### 0.4.2 / 2012-02-22

* Fixed require issue with Mite::VERSION

### 0.4.1 / 2012-02-01

* Fixed Mite.version

### 0.4.0 / 2012-01-31

* Default to https
* Removed jeweler release dependency; now using bundler
* Depends now on activeresource >= 2.3.14; fixed issue with Ruby 1.9

### 0.3.0

* Added User-Agent

### 0.2.4

* Added new resource Mite::TimeEntry::Bookmark (read only)
* Some cleanup.

### 0.2.3

* Fixed bug when using Project#name_with_customer on project without customer.

### 0.2.2

* Added Project#name_with_customer for best practice/convenience

### 0.2.1

* Added archived and active collection-methods to Customer, Project, Service and User

### 0.2.0

* Added singleton resources account and myself (current authenticated user)
* Removed depreciated undo method
* Do not require rubygems
* Added Method to validate the connection to mite

### 0.1.0

* Use absolute classes to prevent collision with other classes

### 0.0.3

* Fixed wrong domain name (old one for testing removed)

### 0.0.2

* Added tracker-resource and methods on time_entry
* Fixed tiny datetimebug
* Dependency of activeresource 2.3.2 and activesupport 2.3.2
 
### 0.0.1

* Initial Version