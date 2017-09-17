// Use this file to write queries to test your data connector
let
    source = BoxAnalytics.Contents("https://api.box.com/2.0/users")
in
    source