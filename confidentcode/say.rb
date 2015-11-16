# Confident Code conf by Advi Grimm

# source : http://confreaks.com/videos/763-rubymidwest2011-confident-code

def say(message, options={})
  return "" if message.nil?
  options[:cowfile] and assert(option[:cowfile].to_s !~ /^\s*$/) # raise an exception unless condition passed on argument is true. See assert method definition below.

  width            = options.fetch(:width) {40}
  eyes             = Maybe(options[:strings])[:eyes]
  cowfile          = options[:cowfile]
  destination      = cowsink(options[:out]).path
  #destination      = WithPath.new(options[:out]).path
  out              = options.fetch(:out) { NullObject.new }
  messages         = Array(messages) # => Coerce
  command          = "cowsay"
  command          << " -W #{width}"
  command          << " -e #{options[:strings][:eyes]}" unless eyes.nil?
  command          << " -f #{options[:cowfile]}" unless cowfile.nil?

  results = messages.map do |message|
    checked_popen(command, "w+", lambda{message}) do |process|
      process.write(message)
      process.close_write
      process.read
    end
  end
  output = results.join("\n")

  out << output

  @logger.info "Wrote to #{destination}"
  output
end

# whatever cowsink returns, it responds to path method.
def cowsink(out)
  case out
  when File then out
  when nil then NullSink.new
  else GenericSink.new(out)
  end
end

# NullSink and GenericSink are decorators. Ils doivent avoir la méthode path

require 'delegate'
class NullSink
  def path; "return value"; end
  def <<(*); end
end


class GeneralSink < SimpleDelegator
  def path; "object: #{inspect}"; end
end


def assert(value, message="Assertion failed")
  raise Exception, message, caller unless value
end

