
  def time_method(method=nil, *args)
    beginning_time = Time.now
    if block_given?
      yield
    else
      self.send(method, args)
    end
    end_time = Time.now
    logger.info "Time elapsed #{(end_time - beginning_time)*1000} mSecs"
  end

  # Example of usage
  time_method do
      # Do hard work here
  end