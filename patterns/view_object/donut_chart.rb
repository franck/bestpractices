# Logic use for display purpose only
# source : http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/#service-objects)

class DonutChart
  def initialize(snapshot)
    @snapshot = snapshot
  end

  def cache_key
    @snapshot.id.to_s
  end

  def data
    # pull data from @snapshot and turn it into a JSON structure
  end
end
