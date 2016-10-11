# Rails old hash diff method (activesupport/lib/active_support/core_ext/hash/diff.rb)
def hash_diff(hash1, hash2)
  hash1.dup.
    delete_if { |k, v| hash2[k] == v }.
    merge!(hash2.dup.delete_if { |k, v| hash1.has_key?(k) })
end
