# TODO: get rid of this class
class Lockdown
  include Singleton

  def initialize
    @conf = Rails.application.config_for(:lockdown)
  end

  def next(except=nil)
    exceptions = []
    exceptions << except unless except.is_a?(Array)
    exceptions = except if except.is_a?(Array)
    exceptions.compact!

    @conf.select { |k, v|
      v > Time.now and (!exceptions.include?(k))
    }.min_by { |_, v|
      v
    }
  end

  def allowed?(action)
    t = @conf[action]
    t.present? and t > Time.now
  end
end
