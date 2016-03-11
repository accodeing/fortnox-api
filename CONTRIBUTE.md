1. Fork it ( http://github.com/my-codeworks/fortnox-api/fork )
2. Clone your fork (`git clone https://github.com/<your GitHub user
   name>/fortnox-api.git`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

### Adding upstream remote

If you want to keep contributing, it is a good idea to add the original repo as
remote server to your clone ( `git remote add upstream
https://github.com/my-codeworks/fortnox-api` ). Then you can do something like
this to update your fork:

1. Fetch branches from upstream (`git fetch upstream`)
2. Checkout your master branch (`git checkout master`)
3. Update it (`git rebase upstream/master`)
4. And push it to your fork (`git push origin master`)

If you want to update another branch:
```
git checkout branch-name
git rebase upstream/branch-name
git push origin branch-name
```
