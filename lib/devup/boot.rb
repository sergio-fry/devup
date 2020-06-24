if ENV.fetch("DEVUP_ENABLED", "true") == "true"
  devup = Devup::Environment.new(
    pwd: `pwd`,
    logger: Devup::Logger.build(ENV.fetch("DEVUP_LOG_LEVEL", "info"))
  )

  begin
    require "spring/commands"

    Spring.after_fork do
      devup.up
    end

    Spring.watch devup.root.join("docker-compose.devup.yml")
  rescue LoadError, ArgumentError
    # Spring is not available

    devup.up
  end
end
