# My Truffle Project

`truffle create contract TwitterClone`

`truffle create migration TwitterClone`

`truffle migrate`

`truffle console`

`let tc = await TwitterClone.deployed()`

`tc.addUser.sendTransaction('quadrixm')`

`tc.getUsers.call()`

`tc.postTweet.sendTransaction('Hello World!')`

`tc.getUserTweet.call('0xBc678fB402888F5eA08ec6f64069d3f774fbFE00')`

`tc.likeTweet.sendTransaction('0xBc678fB402888F5eA08ec6f64069d3f774fbFE00')`

`tc.retweet.sendTransaction('0xBc678fB402888F5eA08ec6f64069d3f774fbFE00')`