MVUrlResolver
=============

Objective C Library to Resolve Short URLs

An example project on how to use the code is include.  To use in your project copy the MVUrlResolver.h and MVUrlResolver.m file into your project.  This code has only been tested on the iPhone; it should work on iOS 4+, could work on iOS 3, but I didn't test it.

To use inside the project, create the MVUrlResolver object.  A delegate method will be called each time a short url is resolved.  If you want to access the urls later, there is a "shortUrlDictionary" dictonary object you can look the short url -> full url inside.

Url's are cached indefinitely and saved out to a plist file.