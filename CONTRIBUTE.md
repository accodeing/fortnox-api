# Contributing

If you want to participate in the development somehow, please send us an email
at info@accodeing.com and let us know. Both small and large contributions are
appreciated.

Please start by reading the [Developer readme](DEVELOPER_README.md).

To contribute:

1. Fork it ( http://github.com/accodeing/fortnox-api/fork )
2. Clone your fork
   (`git clone https://github.com/<your GitHub user name>/fortnox-api.git`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request against our `development` branch

## Adding upstream remote

If you want to keep contributing, it is a good idea to add the original repo as
remote server to your clone
(`git remote add upstream https://github.com/accodeing/fortnox-api`). Then you
can do something like this to update your fork:

1. Fetch branches from upstream (`git fetch upstream`)
2. Checkout your development branch (`git checkout development`)
3. Update it (`git rebase upstream/development`)
4. And push it to your fork (`git push origin development`) (might need a
   `--force` if branches have diverged)
