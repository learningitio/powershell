# Invoke-WebRequest
(Invoke-WebRequest -uri 'https://cat-fact.herokuapp.com/facts').content
(Invoke-WebRequest -uri 'https://cat-fact.herokuapp.com/facts').content | convertfrom-json

# Invoke-RestMethod
(Invoke-RestMethod -uri 'https://cat-fact.herokuapp.com/facts').all

$result = (Invoke-RestMethod -uri 'https://cat-fact.herokuapp.com/facts').all