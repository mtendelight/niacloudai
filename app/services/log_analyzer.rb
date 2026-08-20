class LogAnalyzer
  LOG_FILE = Rails.root.join("log/production.log")

  def self.slow_requests(threshold_ms = 1000, limit = 50)
    threshold = threshold_ms.to_f
    logs = []

    return logs unless File.exist?(LOG_FILE)

    File.foreach(LOG_FILE) do |line|
      next unless line.include?("Completed")

      match = line.match(/Completed .* in (\d+\.?\d*)ms/)
      next unless match

      time = match[1].to_f

      logs << { line: line.strip, duration: time } if time > threshold
    end

    logs.sort_by { |l| -l[:duration].to_f }.first(limit)
  end

  def self.errors(limit = 50)
    logs = []
    return logs unless File.exist?(LOG_FILE)

    File.foreach(LOG_FILE) do |line|
      logs << line.strip if line.match?(/ERROR|FATAL|Exception/)
    end

    logs.last(limit)
  end
end