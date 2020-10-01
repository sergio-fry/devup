if ENV.fetch("DEVUP_ENABLED", "true") == "true"
  devup = Devup::Environment.new(
    pwd: `pwd`,
    logger: Devup::Logger.build(ENV.fetch("DEVUP_LOG_LEVEL", "info"))
  )
  devup.up

  begin
    require "spring/commands"

    Spring.watch devup.root.join("docker-compose.yml")
  rescue LoadError, ArgumentError
    # Spring is not available
  end
end
