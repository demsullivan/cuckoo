module Cuckoo
  class Timer
    include Celluloid
    include Celluloid::Notifications

    attr_accessor :elapsed
    
    def initialize(duration, start_immediately = false)
      @duration = duration
      @elapsed = 0
      
      start if start_immediately
    end

    def start
      @timer = every 1 { tick }
    end

    def pause
      @timer.pause
    end

    def resume
      @timer.resume
    end

    def reset
      @elapsed = 0
    end

    ################################################################################
    private
    ################################################################################
    def tick
      @elapsed += 1

      if @elapsed == @duration
        publish "timer_complete"
        @timer.cancel
      end
    end
  end
end
