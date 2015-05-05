class ApplicationJob
  def self.on_failure(exception, *args)
    puts exception.backtrace.join("\n")
  end
end
