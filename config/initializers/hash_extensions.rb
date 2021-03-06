# Helper method for seperating hashes.
# Removes the keys from hs that are in ls and returns them in a new hash
class Hash
  def extract_keys!(ls)
    res = self.class.new

    ls.each do |k|
      next unless self.include? k
      res[k] = self[k]
      delete k
    end

    res
  end
end
